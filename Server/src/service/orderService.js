import { fbDB } from '../config/firebase.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const getOrderById = async (id) => {
    try{
        const orderRef = fbDB.collection('orders').doc(id);
        const orderDoc = await orderRef.get();
        const resData = orderDoc.data();
        console.log(resData);
        resData.id = id;
        return resData;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postOrder = async (data) => {   
    try{
        //식당 DB의 order_num 갱신
        const restrtRef = fbDB.collection('restaurants').doc(data.restrt_id);
        const updateOrdernum = await restrtRef.update({order_number:FieldValue.increment(1)});
        //식당DB revenues 컬렉션 문서 갱신
        const now = new Date();
        const utcNow = now.getTime() + (now.getTimezoneOffset() * 60 * 1000); // 현재 시간을 utc로 변환한 밀리세컨드값
        const koreaTimeDiff = 9 * 60 * 60 * 1000; // 한국 시간은 UTC보다 9시간 빠름
        const koreaNow = new Date(utcNow + koreaTimeDiff); // utc로 변환된 값을 한국 시간으로 변환시키기 위해 9시간(밀리세컨드)를 더함
        const nowYear = koreaNow.getFullYear(); //요일 일월화수목금토
        const nowMonth = ("0" + (1 + koreaNow.getMonth())).slice(-2);
        const nowDay = koreaNow.getDate() + "";
        const revenueId = nowYear + nowMonth;
        const revenueRef = restrtRef.collection('revenues').doc(revenueId);
        const updateRevenue = await revenueRef.update({
            total_revenue:FieldValue.increment(Number(data.total_price)), //달 매출 갱신
            [nowDay]: FieldValue.increment(Number(data.total_price)), //하루 매출 갱신
        });
        //order 정보 생성
        const refsnapshot = await restrtRef.get();
        const orderData = {
            restrt_id : data.restrt_id,
            user_id : data.user_id, 
            requirements : data.requirements, 
            payment_method : data.payment_method, 
            total_price : Number(data.total_price),
            created_at: FieldValue.serverTimestamp(),
            order_number: Number(refsnapshot.data().order_number),
            state: "checking",
            packed_time: null,
            check_review: false,
            preview_text: data.preview_text,
            orderMenuList: data.orderMenuList
        };
        const orderRes = await fbDB.collection('orders').add(orderData);
        const ref = fbDB.collection('orders').doc(orderRes.id);
        const snapshot = await ref.get();
        const resData = snapshot.data();
        resData.id = orderRes.id;
        return resData;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getOrderListByUserId = async (id) => { //비홀성화
    try{
        const orderRef = fbDB.collection('orders').where('user_id', '==', id).orderBy('created_at', 'desc');
        const ordersnapshot = await orderRef.get();
        const orderIdList = [];
        const orderList = [];
        ordersnapshot.forEach(doc => {
            const orderId = doc.id;
            orderIdList.push(orderId);
        });
        for(let orderId of orderIdList){
            const order = await getOrderById(orderId);
            orderList.push(order);
        }
        return orderList;
    }catch(error){
        throw error;
    }
};

const getOrderListByUserIdWithPage = async (id, page, size, packed) => { //1이 첫 페이지
    try{
        page = Number(page);
        size = Number(size);
        let orderRef;
        if (page == 1){
            if(packed == undefined){
                orderRef = fbDB.collection('orders').where('user_id', '==', id).orderBy('created_at', 'desc')
                        .limit(size);
            }else{
                orderRef = fbDB.collection('orders').where('user_id', '==', id).where('state', '==', "packed").orderBy('created_at', 'desc')
                        .limit(size);
            }
        }else{
            if(packed == undefined){
                const before = fbDB.collection('orders').where('user_id', '==', id).orderBy('created_at', 'desc')
                                .limit((page-1)*size);
                const snapshot = await before.get();
                const last = snapshot.docs[snapshot.docs.length - 1];
                orderRef = fbDB.collection('orders').where('user_id', '==', id).orderBy('created_at', 'desc')
                            .startAfter(last.data().created_at).limit(size);
            }else{
                const before = fbDB.collection('orders').where('user_id', '==', id).where('state', '==', "packed").orderBy('created_at', 'desc')
                                .limit((page-1)*size);
                const snapshot = await before.get();
                const last = snapshot.docs[snapshot.docs.length - 1];
                orderRef = fbDB.collection('orders').where('user_id', '==', id).where('state', '==', "packed").orderBy('created_at', 'desc')
                            .startAfter(last.data().created_at).limit(size);
            }
        }
        const ordersnapshot = await orderRef.get();
        const orderIdList = [];
        const orderList = [];
        ordersnapshot.forEach(doc => {
            const orderId = doc.id;
            orderIdList.push(orderId);
        });
        for(let orderId of orderIdList){
            const order = await getOrderById(orderId);
            orderList.push(order);
        }
        return orderList;
    }catch(error){
        throw error;
    }
}

export default {
    getOrderById, 
    postOrder,
    getOrderListByUserId,
    getOrderListByUserIdWithPage,
};