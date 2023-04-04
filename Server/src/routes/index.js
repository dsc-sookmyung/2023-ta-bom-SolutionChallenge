import { Router } from 'express';
import userRouter from './userRouter.js';
import restrtRouter from './restrtRouter.js';
import orderRouter from './orderRouter.js';
import reviewRouter from './reviewRouter.js';

const router = Router();

router.use('/user', userRouter);
router.use('/restrt', restrtRouter);
router.use('/order', orderRouter);
router.use('/review', reviewRouter);

export default router;