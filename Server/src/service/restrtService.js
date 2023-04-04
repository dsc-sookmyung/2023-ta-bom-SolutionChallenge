import { fbDB } from '../config/firebase.js';
import {uploadFile} from '../middleware/image.js';
import {v4 as uuidv4} from 'uuid';
import {changeState, makeSchedule} from '../middleware/changeState.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const postRestrt = async (file, data) => {
    try{
        if (file){
            const uploadFileUrl = await uploadFile(file);
            data.img = uploadFileUrl;
        }else{
            data.img = null;
        }
        data.category = Number(data.category);
        data.star_rating = Number(data.star_rating);
        data.review_count = Number(data.review_count);
        data.order_number = Number(data.order_number);
        data.opening_hours = JSON.parse(data.opening_hours);
        data.geo_point = JSON.parse(data.geo_point);

        const res = await fbDB.collection('restaurants').add(data);
        changeState(res.id);
        makeSchedule(res.id);
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
            const res = await fbDB.collection('menus').add(data[i]);
            menuIdList.push({id: res.id});

            const restrtId = data[i].restrt_id;
            const restrtRef = fbDB.collection('restaurants').doc(restrtId);
            const restrtRes = await restrtRef.update({
                menu_list: FieldValue.arrayUnion(res.id)
            });
        };
        return menuIdList;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postOption = async (id, data) => {
    try{
        const options = [];
        for (let doc of data){
            for (let contdoc of doc.content){
                contdoc.id = uuidv4();
            }
            const resOption = await fbDB.collection('menu-options').add(doc);
            const optRef = fbDB.collection('menu-options').doc(resOption.id);
            const optSnapshot = await optRef.get();
            let optData = optSnapshot.data();
            optData.id = resOption.id;
            options.push(optData);
            //메뉴 디비에 해당 메뉴의 옵션id를 리스트에 추가
            const menuRef = fbDB.collection('menus').doc(id);
            const resMenu = await menuRef.update({
                option_id: FieldValue.arrayUnion(resOption.id)
            });
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
        const restrtSnapshot = await restRef.get();
        if (!restrtSnapshot.exists){
            throw {message: "There is no such restrt corresponding to the provided identifier."};
        }else{
            let restrtData = restrtSnapshot.data();
            restrtData.id = id;
            const menuIdList = restrtData.menu_list;
            const menuList = [];
            const categoryList=[];
            for (let menuId of menuIdList){
                const menuRef = fbDB.collection('menus').doc(menuId);
                const menuSnapshot = await menuRef.get();
                const menuData = menuSnapshot.data();
                menuData.id = menuSnapshot.id;
                if (categoryList.indexOf(menuData.detail_category) > -1){
                    const index = categoryList.indexOf(menuData.detail_category);
                    menuList[index].menuList.push(menuData);
                }else{
                    categoryList.push(menuData.detail_category);
                    let x = {detail_category: menuData.detail_category, menuList:[menuData]};
                    menuList.push(x);
                }
            }
            const sortedMenuList = menuList.sort((a, b) => a.detail_category < b.detail_category ? -1 : 1);
            restrtData.menu_list = sortedMenuList;
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
        const restRef = fbDB.collection('restaurants').doc(id);
        const snapshot = await restRef.get();
        const menuIdList = snapshot.data().menu_list;
        let menuList = [];
        for (let menuId of menuIdList){ //async/await은 forEach문 안에서 사용할 수 없다.
            const menuRef = fbDB.collection('menus').doc(menuId);
            const menusnapshot = await menuRef.get();
            const menuData = menusnapshot.data();
            menuData.menuId = menuId
            menuList.push(menuData);
        }
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

const getMenuWithOptions = async (id) =>{
    try{
        const menuRef = fbDB.collection('menus').doc(id);
        const menusnapshot = await menuRef.get();
        const optionIdList = menusnapshot.data().option_id;
        const menuData = menusnapshot.data();
        menuData.id = menusnapshot.id;
        let optionList = [];
        //메뉴 아이디
        for (let optionId of optionIdList){ //async/await은 forEach문 안에서 사용할 수 없다.
            const optionRef = fbDB.collection('menu-options').doc(optionId);
            const optionsnapshot = await optionRef.get();
            const optionData = optionsnapshot.data();
            optionData.id = optionId;
            optionList.push(optionData);
        };
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
        const restrtRef = fbDB.collection('restaurants').doc(restrtId);
        const res = await restrtRef.update({
            menu_list: FieldValue.arrayRemove(menuId)
        });
        const data = {restrtId: restrtId, menuId: menuId};
        return data;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const deleteOption = async (menuId, optionId) => {
    try{
        const menuRef = fbDB.collection('menus').doc(menuId);
        const res = await menuRef.update({
            option_id: FieldValue.arrayRemove(optionId)
        });
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
};