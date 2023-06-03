import { fbDB } from '../config/firebase.js';
import {uploadFile} from '../middleware/image.js';
import {v4 as uuidv4} from 'uuid';
import {changeState, makeSchedule, makeMonthRevenueDoc, makeDayRevenueDoc} from '../middleware/changeState.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const postRestrt = async (file, data) => {
    try{
        if (file){
            const uploadFileUrl = await uploadFile(file);
            data.img = uploadFileUrl;
        }else{
            data.img = null;
        }
        //자료형 변환
        data.category = Number(data.category);
        data.star_rating = Number(data.star_rating);
        data.review_count = Number(data.review_count);
        data.order_number = Number(data.order_number);
        data.opening_hours = JSON.parse(data.opening_hours);
        data.geo_point = JSON.parse(data.geo_point);
        const res = await fbDB.collection('restaurants').add(data);
        changeState(res.id);
        makeSchedule(res.id);
        makeMonthRevenueDoc(res.id);
        makeDayRevenueDoc(res.id);
        const restId = {id: res.id};
        return restId;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postMenu = async (files, data) => { //❗데이터 객체 개수와 이미지 리스트 개수 같아야함.
    try{
        const menuIdList = [];
        for (let i = 0; i < data.length; i++){
            if (files[i]){
                data[i].img = await uploadFile(files[i]);
            }else{
                data[i].img = null;
            }
            const menuData = {
                name: data[i].name,
                price: data[i].price,
                img: data[i].img,
                detail_category: data[i].detail_category,
                container: Number(data[i].container),
                description: data[i].description,
                disabled: data[i].disabled
            }
            const restrtId = data[i].restrt_id;
            const menuCollection = fbDB.collection('restaurants').doc(restrtId).collection('menus');
            const res = await menuCollection.add(menuData);
            menuIdList.push({id: res.id});
        };
        return menuIdList;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postOption = async (restrtId, menuId, data) => {
    try{
        const options = [];
        for (let doc of data){
            for (let contdoc of doc.contents){
                contdoc.id = uuidv4();
            }
            console.log(restrtId);
            console.log(menuId);
            const optionCollection = fbDB.collection('restaurants').doc(restrtId).collection('menus').doc(menuId).collection('menu-options');
            const resOption = await optionCollection.add(doc);
            const optData = doc;
            optData.id = resOption.id;
            options.push(optData);
        };
        return options;//optionIdList;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getRestrt = async (id) => {
    try{
        const restRef = fbDB.collection('restaurants').doc(id);
        const restrtDoc = await restRef.get();
        if (!restrtDoc.exists){
            throw {message: "There is no such restrt corresponding to the provided identifier."};
        }else{
            const restrtData = restrtDoc.data();
            restrtData.id = id;

            const menusRef = fbDB.collection('restaurants').doc(id).collection('menus');
            const menusSnapshot = await menusRef.get();
            restrtData.menu_list = [];
            const categoryList = [];
            menusSnapshot.forEach(doc => {
                const menuData = doc.data();
                menuData.restrt_id = id;
                menuData.id = doc.id;
                const index = categoryList.indexOf(doc.data().detail_category);
                if(index > -1){
                    restrtData.menu_list[index].menuList.push(menuData);
                }else{
                    categoryList.push(doc.data().detail_category);
                    const x = {detail_category: doc.data().detail_category, menuList:[menuData]};
                    restrtData.menu_list.push(x);
                }
            });
            restrtData.menu_list.sort((a, b) => a.detail_category < b.detail_category ? -1 : 1);
            return restrtData;
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getRestrtList = async () => { //🔺 위치에 따라 리스트 선정 필요
    try{
        const restRef = fbDB.collection('restaurants');
        const restrtsnapshot = await restRef.where('state', 'in', ["open", "closed"]).get();
        let restrtListData = [];
        restrtsnapshot.forEach(doc => {
            const restrtData = doc.data();
            restrtData.id = doc.id;
            restrtListData.push(restrtData);
        });
        if (restrtListData.length == 0){
            return null;
        }else{
            return restrtListData;
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getRestrtListWithCategory = async (c) => { //🔺 위치에 따라 리스트 선정 필요
    try{
        const restRef = fbDB.collection('restaurants');
        if ( Number(c) == 0){
            return getRestrtList();
        }
        const restrtsnapshot = await restRef.where('category', '==', Number(c)).where('state', 'in', ['open', 'closed']).get();
        let restrtListData = [];
        restrtsnapshot.forEach(doc => {
            const restrtData = doc.data();
            restrtData.id = doc.id;
            restrtListData.push(restrtData);
        });
        if (restrtListData.length == 0){
            return null;
        }else{
            return restrtListData;
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getMenuList = async (id) => {
    try{
        const menusCollection = fbDB.collection('restaurants').doc(id).collection('menus');
        const menuSnapshot = await menusCollection.get();
        let menuList = [];
        menuSnapshot.forEach(doc => {
            const menuData = doc.data();
            menuData.id = doc.id;
            menuData.restrtId = id;
            menuList.push(menuData);
        });
        if (menuList == 0){
            throw {message: "empty error"};
        }else{
            return menuList;
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getMenuWithOptions = async (restrtId, menuId) =>{
    try{
        const menuRef = fbDB.collection('restaurants').doc(restrtId).collection('menus').doc(menuId);
        const menuSnapshot = await menuRef.get();
        const menuData = menuSnapshot.data();
        menuData.id = menuSnapshot.id;
        //메뉴 아이디
        const optionList = [];
        const optionRef = menuRef.collection('menu-options');
        const optionSnapshot = await optionRef.get();
        optionSnapshot.forEach(doc => {
            const optionData = doc.data();
            optionData.id = doc.id;
            optionList.push(optionData);
        });
        const menuWithOption = {menu: menuData, option: optionList};
        return menuWithOption;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const deleteRestrt = async (id) => {
    try{
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const res = await restrtRef.update({state: "disabled"});
        const restrtId = {id: id};
        return restrtId;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const deleteMenu = async (restrtId, menuId) => {
    try{
        const menusRef = fbDB.collection('restaurants').doc(restrtId).collection('menus');
        const deleteMenu = await menusRef.doc(menuId).delete();
        //하위 컬렉션인 옵션 삭제
        const data = {restrtId: restrtId, menuId: menuId};
        return data;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const deleteOption = async (restrtId, menuId, optionId) => {
    try{
        const optionsRef = fbDB.collection('restaurants').doc(restrtId).collection('menus').doc(menuId).collection('menu-options');
        const deleteOption = await optionsRef.doc(optionId).delete();
        const data = {menuId: menuId, optionId: optionId};
        return data;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const searchRestrt = async (data) => { //🔺 위치에 따라 리스트 선정 필요
    try{
        let restrtListData = [];
        //식당 이름 검색
        const restrtRef = fbDB.collection('restaurants');
        const restrtsnapshot = await restrtRef.where('state', 'in', ['open', 'closed']).get();
        restrtsnapshot.forEach(doc => {
            if(doc.data().name.indexOf(data) != -1){
                const restrtData = doc.data();
                restrtData.id = doc.id;
                restrtListData.push(restrtData);
            }
        });

        //메뉴 이름 검색
        const restrtIdList = [];
        const menuRef = fbDB.collection('menus');
        const menusnapshot = await menuRef.where('disabled', '==', false).get();
        menusnapshot.forEach(doc => {
            if(doc.data().name.indexOf(data) != -1){ //메뉴이름에 검색어가 포함된다면
                const restrtId = doc.data().restrt_id;
                if(restrtListData.find(x => x.id === restrtId) == undefined ){ //&& (restrtIdList.indexOf(restrtId) != -1) //데이터에 저장되어있지 않다면
                    restrtIdList.push(restrtId);
                }
            }
        });
        if (restrtIdList.length != 0) {
            for (let id of restrtIdList){
                const ref = fbDB.collection('restaurants').doc(id);
                const resSnapshot = await ref.get();
                if(resSnapshot.data().state == "open"){ //음식점이 open이라면
                    const restrtData = resSnapshot.data();
                    restrtData.id = resSnapshot.id;
                    restrtListData.push(restrtData);
                }
            }
        }
        if (restrtListData.length == 0){
            return null;
        }else{
            return restrtListData;
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getRevenue = async (id) => {
    try{
        const now = new Date();
        const utcNow = now.getTime() + (now.getTimezoneOffset() * 60 * 1000); // 현재 시간을 utc로 변환한 밀리세컨드값
        const koreaTimeDiff = 9 * 60 * 60 * 1000; // 한국 시간은 UTC보다 9시간 빠름
        const koreaNow = new Date(utcNow + koreaTimeDiff); // utc로 변환된 값을 한국 시간으로 변환시키기 위해 9시간(밀리세컨드)를 더함
        const nowYear = koreaNow.getFullYear(); //요일 일월화수목금토
        const nowMonth = ("0" + (1 + koreaNow.getMonth())).slice(-2);
        const nowDay = koreaNow.getDate() + "";
        const revenueId = nowYear + nowMonth;
        //오늘 매출, 이번달 매출
        const revenueRef = fbDB.collection('restaurants').doc(id).collection('revenues').doc(revenueId);
        const revenueSnapshot = await revenueRef.get();
        const todayRevenue = revenueSnapshot.data()[nowDay];
        const monthRevenue = revenueSnapshot.data().total_revenue;
        //최근 6달의 매출
        const lastSixRevenueList = [];
        const idList = [];
        const Monthnum = Number(nowMonth);
        for (let i=5 ; i>=0 ; i--){
            if(Monthnum - i > 0){
                const month = ("0"+(Monthnum - i)).slice(-2);
                const id = nowYear + month;
                idList.push(id);
            }else{
                const month = ("0"+(Monthnum - i + 12)).slice(-2);
                const year = nowYear - 1;
                const id = year + month;
                idList.push(id);
            }
        }
        for (let revenueid of idList){
            const ref = fbDB.collection('restaurants').doc(id).collection('revenues').doc(revenueid);
            const doc = await ref.get();
            let data;
            if (doc.data() == undefined ){
                data = {
                    id: revenueid,
                    total_revenue: 0
                };
            }else{
                data = {
                    id: revenueid,
                    total_revenue: doc.data().total_revenue
                };
            }
            lastSixRevenueList.push(data);
        }
        const resData = {
            todayRevenue: todayRevenue,
            monthRevenue: monthRevenue,
            lastSixRevenueList: lastSixRevenueList
        }
        return resData;
    }catch (error){
        console.log(error);
        throw error;
    }
};

export default {
    postRestrt,
    postMenu,
    postOption,
    getRestrt,
    getRestrtList,
    getMenuList,
    getMenuWithOptions,
    deleteRestrt,
    deleteMenu,
    deleteOption,
    searchRestrt,
    getRestrtListWithCategory,
    getRevenue,
};