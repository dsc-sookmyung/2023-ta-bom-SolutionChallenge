import { Router } from 'express';
import orderController from '../controllers/orderController.js';

const router = Router();

router.post('', orderController.postOrder);
router.get('/:id', orderController.getOrderById); 
router.get('/user/:id', orderController.getOrderListByUserIdWithPage); //?page=2&size=3

export default router;
