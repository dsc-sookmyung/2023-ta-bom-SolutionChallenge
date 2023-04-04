import express from 'express';
import { reviewService } from "../service/index.js";

/**
 *  @route POST /review
 *  @desc post restaurant reviews data
 *  @access Private
 */
const postReview = async (req, res) => {
    const data = req.body;
    let file = req.file;
    try {
        const postReview = await reviewService.postReview(file, data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "리뷰 생성 성공",
            data: postReview,
        });
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

/**
 *  @route GET /review/restrt/:id
 *  @desc get restaurant reviews data
 *  @access Private
 */
const getReviewListByRestrtIdWithPage = async (req, res) => {
    const { id } = req.params;
    try {
        const page = req.query.page;
        const size = req.query.size;
        //쿼리 값이 없으면
        if((page == undefined) || (size == undefined) ){
            const getReviewListByRestrtId = await reviewService.getReviewListByRestrtId(id);
            return res.status(200).json({
                status: 200,
                success: true,
                message: "음식점별 리뷰 리스트 전체 읽기 성공",
                data: getReviewListByRestrtId,
            });
        }

        //쿼리 값이 있으면
        if (page < 1) { //0이하면 에러
            return res.status(400).json({
                status: 400,
                success: false,
                message: '⛔잘못된 요청. 페이지는 1 이상부터 가능',
            });
        }

        const getReviewListByRestrtIdWithPage = await reviewService.getReviewListByRestrtIdWithPage(id, page, size);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "페이지 형태로 음식점별 리뷰 리스트 읽기 성공",
            data: getReviewListByRestrtIdWithPage,
        });
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};


/**
 *  @route GET /review/user/:id
 *  @desc get restaurant reviews data
 *  @access Private
 */
const getReviewListByUserIdWithPage = async (req, res) => {
    const { id } = req.params;
    try {
        const page = req.query.page;
        const size = req.query.size;
        //쿼리 값이 없으면
        if((page == undefined) || (size == undefined) ){
            const getReviewListByUserId = await reviewService.getReviewListByUserId(id);
            return res.status(200).json({
                status: 200,
                success: true,
                message: "사용자별 음식점 리뷰 리스트 전체 읽기 성공",
                data: getReviewListByUserId,
            });
        }

        //쿼리 값이 있으면
        if (page < 1) { //0이하면 에러
            return res.status(400).json({
                status: 400,
                success: false,
                message: '⛔잘못된 요청. 페이지는 1 이상부터 가능',
            });
        }
        const getReviewListByUserIdWithPage = await reviewService.getReviewListByUserIdWithPage(id, page, size);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "페이지 형태로 사용자별 음식점 리뷰 리스트 읽기 성공",
            data: getReviewListByUserIdWithPage,
        });
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

/**
 *  @route delete /review/:id
 *  @desc delete restaurant reviews data
 *  @access Private
 */
const deleteReview = async (req, res) => {
    const { id } = req.params;
    try {
        const deleteReview = await reviewService.deleteReview(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "리뷰 정보 삭제 성공",
            data: deleteReview,
        });
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

export default {
    postReview,
    getReviewListByRestrtIdWithPage,
    getReviewListByUserIdWithPage,
    deleteReview,
};