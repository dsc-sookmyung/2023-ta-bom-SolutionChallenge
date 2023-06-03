import express from 'express';
import { orderService } from "../service/index.js";

/**
 *  @route GET /order/:id
 *  @desc get order data by order Id
 *  @access Private
 */
const getOrderById = async (req, res) => {
    const { id } = req.params;
    try {
        const getOrderById = await orderService.getOrderById(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "주문 정보 읽기 성공",
            data: getOrderById,
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
 *  @route POST /order
 *  @desc post order
 *  @access Private
 */
const postOrder = async (req, res) => {
    const data = req.body;
    try {
        const postOrder = await orderService.postOrder(data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "주문 전송 성공",
            data: postOrder,
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
 *  @route GET /order/user/{id}
 *  @desc get order LIst data by user Id
 *  @access Private
 */
const getOrderListByUserId = async (req, res) => {
    const { id } = req.params;
    try {
        const getOrderListByUserId = await orderService.getOrderListByUserId(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "사용자별 주문 리스트 읽기 성공",
            data: getOrderListByUserId,
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
 *  @route GET /order/user/{id}
 *  @desc get order LIst data by user Id
 *  @access Private
 */
const getOrderListByUserIdWithPage = async (req, res) => {
    const { id } = req.params;
    try {
        const page = req.query.page;
        const size = req.query.size;
        const packed = req.query.packed;
        //쿼리 값이 없으면
        if((page == undefined) || (size == undefined) ){
            const getOrderListByUserId = await orderService.getOrderListByUserId(id);
            return res.status(200).json({
                status: 200,
                success: true,
                message: "사용자별 주문 리스트 전체 읽기 성공",
                data: getOrderListByUserId,
            });
        }

        //쿼리 값이 있으면
        if (page < 1) { //0이하면 에러
            return res.status(400).json({
                status: 400,
                success: false,
                message: '잘못된 요청. 페이지는 1 이상부터 가능',
            });
        }
        if ((packed != undefined) && (packed != 1)) { 
            return res.status(400).json({
                status: 400,
                success: false,
                message: '잘못된 요청. packed는 1 혹은 undifined 값만을 가짐',
            });
        }
        const getOrderListByUserIdWithPage = await orderService.getOrderListByUserIdWithPage(id, page, size, packed);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "페이지 형태로 사용자별 주문 리스트 읽기 성공",
            data: getOrderListByUserIdWithPage,
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
    getOrderById, 
    postOrder,
    getOrderListByUserIdWithPage, 
};