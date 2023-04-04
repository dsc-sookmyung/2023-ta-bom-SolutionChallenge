import { fbDB } from '../config/firebase.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const getOrderById = async (id) => {
    try{
        const orderRef = fbDB.collection('orders').doc(id);
        const ordersnapshot = await orderRef.get();
        const orderMenuIdList = ordersnapshot.data().menu_id_list; //주문메뉴 id 리스트
        let orderMenuList = [];
        for (let orderMenuId of orderMenuIdList){ //async/await은 forEach문 안에서 사용할 수 없다.
            const orderMenuRef = fbDB.collection('order-menus').doc(orderMenuId);
            const orderMenusnapshot = await orderMenuRef.get();
            const menuId = orderMenusnapshot.data().menu_id; //메뉴 id
            const menuRef = fbDB.collection('menus').doc(menuId);
            const menusnapshot = await menuRef.get(); //메뉴 이름 확인용
            let optionList = [];
            for (let op of orderMenusnapshot.data().options){ //주문한 메뉴의 옵션 리스트
                const optionRef = fbDB.collection('menu-options').doc(op.ops_id); //옵션 id
                const optionsnapshot = await optionRef.get();
                let contentList = [];
                for (let cid of op.content_id){ //["1", "2"]
                    for (let i of optionsnapshot.data().content){
                        if (i.id == cid){
                            contentList.push({id: cid, name: i.name, price: i.price, container: i.container});
                        }
                    }
                }
                optionList.push({id: op.ops_id, option_name: optionsnapshot.data().option_name, content: contentList}) //옵션 아이디, 옵션 이름, 콘텐츠 id
            };
            orderMenuList.push({orderMenuId: orderMenuId, name: menusnapshot.data().name, amount: orderMenusnapshot.data().amount, price: menusnapshot.data().price,
                            menu_option: optionList, container: menusnapshot.data().container });
        };
        const restrtRef = fbDB.collection('restaurants').doc(ordersnapshot.data().restrt_id); //옵션 id
        const restrtsnapshot = await restrtRef.get();
        const order = {id:ordersnapshot.id, user_id: ordersnapshot.data().user_id, state: ordersnapshot.data().state, restrt_id: ordersnapshot.data().restrt_id, orderMenuList: orderMenuList, 
                        total_price: ordersnapshot.data().total_price, requirements: ordersnapshot.data().requirements, payment_method: ordersnapshot.data().payment_method, 
                        order_number: ordersnapshot.data().order_number, created_at: ordersnapshot.data().created_at, 
                        restrt_name: restrtsnapshot.data().name, restrt_img: restrtsnapshot.data().img, check_review: ordersnapshot.data().check_review
                    };
        return order;
    }catch (error){
        console.log(error);
        throw error;
    }
};

//for test
const changeOrderState = async (id) => {
    try{
        const orderRef = fbDB.collection('orders').doc(id);
        setTimeout(() => orderRef.update({state: "accepted"}), 5000);
        setTimeout(() => orderRef.update({state: "cooked"}), 10000);
        setTimeout(() => {
            orderRef.update({state: "packed"});
            orderRef.update({packed_time: FieldValue.serverTimestamp()});
        }, 15000);

    }catch (error){
        console.log(error);
        throw error;
    }

}

const postOrder = async (data) => {   
    try{
        let menu_list = [];
        for (let menu of data.orderMenuList){
            const res = await fbDB.collection('order-menus').add(menu);
            menu_list.push(res.id);
        }
        const restrtRef = fbDB.collection('restaurants').doc(data.restrt_id);
        const updateOrdernum = await restrtRef.update({order_number:FieldValue.increment(1)});
        const refsnapshot = await restrtRef.get();
        const order = {
            restrt_id : data.restrt_id,
            user_id : data.user_id, 
            requirements : data.requirements, 
            payment_method : data.payment_method, 
            total_price : Number(data.total_price),
            created_at: FieldValue.serverTimestamp(),
            menu_id_list: menu_list,
            order_number: Number(refsnapshot.data().order_number),
            state: "checking",
            packed_time: null,
            check_review: false,
        };
        const res = await fbDB.collection('orders').add(order);
        const ref = fbDB.collection('orders').doc(res.id);
        const snapshot = await ref.get();
        const resData = snapshot.data();
        resData.id = res.id;
        //for test
        changeOrderState(res.id);
        return resData;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getOrderListByUserId = async (id) => {
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