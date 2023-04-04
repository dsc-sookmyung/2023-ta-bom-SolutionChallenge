import { fbAuth as getAuth } from '../config/firebase.js';
import { fbDB } from '../config/firebase.js';
import {uploadFile, removeFile} from '../middleware/image.js';
import config from '../config/index.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const updateUser = async (file, uid, newUserRecord) => {
    try{
        if (file != undefined ){ //파일이 있으면
            let oldfileName;
            const UserRecord = await getAuth.getUser(uid);
            const oldfileURL = UserRecord.photoURL.slice(0, 60);
            if( oldfileURL == config.originUrl){ //스토리지에 있는 이미지라면
                oldfileName = UserRecord.photoURL.slice(60); //기존 이미지 이름 찾기
                const uploadFileUrl = await uploadFile(file);
                newUserRecord.photoURL = uploadFileUrl;
                const userRecord = await getAuth.updateUser(uid, newUserRecord);
                await removeFile(oldfileName);
            }else{
                //이미지 업로드 및 DB photoURL 업데이트
                const uploadFileUrl = await uploadFile(file);
                newUserRecord.photoURL = uploadFileUrl;
                const userRecord = await getAuth.updateUser(uid, newUserRecord);
            }
        }else{ //이미지 파일이 없으면
            const userRecord = await getAuth.updateUser(uid, newUserRecord);
        }
        return await getAuth.getUser(uid);
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postUserLocation = async (uid, data) => {
    try{
        const usrRef = fbDB.collection('user-location').doc(uid);
        const addusrdata = await usrRef.set(data);
        return addusrdata;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getUser = async (uid) => {
    try{
        let getUser = await getAuth.getUser(uid);
        return getUser;
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getUserLocation = async (uid) => {
    try{
        const usrRef = fbDB.collection('user-location').doc(uid);
        const addressUser = await usrRef.get();
        const locData = addressUser.data();
        return locData;
    }catch (error){
        console.log(error);
        throw error;
    }
}

export default {
    updateUser,
    getUser,
    postUserLocation,
    getUserLocation,
};