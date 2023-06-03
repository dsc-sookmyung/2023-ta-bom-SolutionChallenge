import { fbDB } from '../config/firebase.js';
import {uploadFile} from '../middleware/image.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const postReview = async (file, data) => {
    try{
        const orderRef = fbDB.collection('orders').doc(data.order_id);
        const doc = await orderRef.get();
        if(doc.data().check_review == true){
            throw new Error('⛔해당 주문번호는 이미 리뷰가 존재합니다.')
        }
        if (file){
            const uploadFileUrl = await uploadFile(file);
            data.img = uploadFileUrl;
        }else{
            data.img = null;
        }
        data.star_rating = Number(data.star_rating);
        data.created_at = FieldValue.serverTimestamp();
        const resReview = await fbDB.collection('reviews').add(data);
        //주문 DB에 check_review값을 true로 변경
        const orderRes = await orderRef.update({check_review: true});
        //음식점 DB에서 리뷰 갯수 업데이트
        const restrtRef = fbDB.collection('restaurants').doc(data.restrt_id);
        const update_review_count = await restrtRef.update({
            review_count: FieldValue.increment(1)
        });
        //음식점 DB에서 평균 별점 업데이트
        const restrtSnapshot = await restrtRef.get();
        let newStarRate = (Number(restrtSnapshot.data().star_rating) * (Number(restrtSnapshot.data().review_count) - 1) + data.star_rating)/Number(restrtSnapshot.data().review_count);
        newStarRate = newStarRate.toFixed(1);
        const update_star_rating = await restrtRef.update({star_rating: Number(newStarRate)});
        return {id: resReview.id};
    }catch (error){
        console.log(error);
        throw error;
    }
};

const postEmoji = async (id, data) => {
    try{
        const emojiData = data.emoji;
        const reviewRef =  fbDB.collection('reviews').doc(id);
        const updateEmoji = await reviewRef.update({
            emoji: emojiData
        });
        const reviewDoc = await reviewRef.get();
        const resData = reviewDoc.data();
        resData.id = id;
        console.log(resData);
        return resData;
    }catch(error){
        console.log(error);
        throw error;
    }
};

const getReviewListByRestrtId = async (id) => {
    try{
        const reviewRef = fbDB.collection('reviews');
        const snapshot = await reviewRef.where('restrt_id', '==', id).orderBy('created_at', 'desc').get();
        const reviewsByRestrtId = [];
        if (!snapshot.empty){
            snapshot.forEach(doc => {
                const reviewData = doc.data();
                reviewData.id = doc.id;
                reviewsByRestrtId.push(reviewData);
            }); 
            return reviewsByRestrtId;             
        }else{
            return [];
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getReviewListByRestrtIdWithPage = async (id, page, size) => {
    try{
        page = Number(page);
        size = Number(size);
        let reviewRef;
        if (page == 1){
            reviewRef = fbDB.collection('reviews').where('restrt_id', '==', id).orderBy('created_at', 'desc')
                        .limit(size);
        }else{
            const before = fbDB.collection('reviews').where('restrt_id', '==', id).orderBy('created_at', 'desc')
                            .limit((page-1)*size);
            const snapshot = await before.get();
            const last = snapshot.docs[snapshot.docs.length - 1];
            reviewRef = fbDB.collection('reviews').where('restrt_id', '==', id).orderBy('created_at', 'desc')
                        .startAfter(last.data().created_at).limit(size);
        }
        const reviewSnapshot = await reviewRef.get();
        const reviewsByRestrtId = [];
        if (!reviewSnapshot.empty){
            reviewSnapshot.forEach(doc => {
                const reviewData = doc.data();
                reviewData.id = doc.id;
                reviewsByRestrtId.push(reviewData);
            }); 
            return reviewsByRestrtId;             
        }else{
            return [];
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const getReviewListByUserId = async (id) => {
    try{
        const reviewRef = fbDB.collection('reviews');
        const snapshot = await reviewRef.where('user_id', '==', id).orderBy('created_at', 'desc').get();
        const reviewsListByUserId = [];
        if (!snapshot.empty){
            snapshot.forEach(doc => {
                const reviewData = doc.data();
                reviewData.id = doc.id;
                reviewsListByUserId.push(reviewData);
            }); 
            return reviewsListByUserId;             
        }else{
            return [];
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};


const getReviewListByUserIdWithPage = async (id, page, size) => {
    try{
        page = Number(page);
        size = Number(size);
        let reviewRef;
        if (page == 1){
            reviewRef = fbDB.collection('reviews').where('user_id', '==', id).orderBy('created_at', 'desc')
                        .limit(size);
        }else{
            const before = fbDB.collection('reviews').where('user_id', '==', id).orderBy('created_at', 'desc')
                            .limit((page-1)*size);
            const snapshot = await before.get();
            const last = snapshot.docs[snapshot.docs.length - 1];
            reviewRef = fbDB.collection('reviews').where('user_id', '==', id).orderBy('created_at', 'desc')
                        .startAfter(last.data().created_at).limit(size);
        }
        const reviewSnapshot = await reviewRef.get();
        const reviewsListByUserId = [];
        if (!reviewSnapshot.empty){
            reviewSnapshot.forEach(doc => {
                const reviewData = doc.data();
                reviewData.id = doc.id;
                reviewsListByUserId.push(reviewData);
            }); 
            return reviewsListByUserId;             
        }else{
            return [];
        }
    }catch (error){
        console.log(error);
        throw error;
    }
};

const deleteReview = async (id) => {
    try{
        const reviewRef = fbDB.collection('reviews').doc(id);
        const snapshot = await reviewRef.get();
        const restrtId = snapshot.data().restrt_id;
        const res = await reviewRef.delete();
        const restrtRef  = fbDB.collection('restaurants').doc(restrtId);
        const minusReviewCount = await restrtRef.update({
            review_count: FieldValue.increment(-1)
        });
        const data = {reviewId: id};
        return data;
    }catch (error){
        console.log(error);
        throw error;
    }
};

export default {
    postReview,
    postEmoji,
    getReviewListByRestrtId,
    getReviewListByRestrtIdWithPage,
    getReviewListByUserId,
    getReviewListByUserIdWithPage,
    deleteReview,
};
