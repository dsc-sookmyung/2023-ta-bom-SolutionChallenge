import schedule from 'node-schedule-tz';
import { fbDB } from '../config/firebase.js';
import { Timestamp, FieldValue } from 'firebase-admin/firestore';

const changeOpen = async (id) => {
    try {
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const res = await restrtRef.update({state: "open"});
        console.log('open', id);
    }catch (error){
        console.log(error);
        throw error;
    }
};

const changeClosed = async (id) => {
    try {
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const res = await restrtRef.update({state: "closed"});
        console.log('close', id);
    }catch (error){
        console.log(error);
        throw error;
    }
};

const changeOrderNumber = async (id) => {
    try {
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const res = await restrtRef.update({order_number: 0});
    }catch (error){
        console.log(error);
        throw error;
    }
};

//특정 식당 영업 상태 업데이트
const changeState = async (id) =>{
    try {
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const restrtSnapshot = await restrtRef.get();
        const timeList = restrtSnapshot.data().opening_hours; //월화수목금토일
        const now = new Date();
        const utcNow = now.getTime() + (now.getTimezoneOffset() * 60 * 1000); // 현재 시간을 utc로 변환한 밀리세컨드값
        const koreaTimeDiff = 9 * 60 * 60 * 1000; // 한국 시간은 UTC보다 9시간 빠름
        const koreaNow = new Date(utcNow + koreaTimeDiff); // utc로 변환된 값을 한국 시간으로 변환시키기 위해 9시간(밀리세컨드)를 더함
        const nowDay = koreaNow.getDay(); //요일 일월화수목금토
        const nowHour = koreaNow.getHours(); //시
        const nowMinutes = koreaNow.getMinutes(); //분

        const dayTime = timeList[(nowDay + 6) % 7]; //가게 특정요일 운영시간

        if(dayTime == "휴무"){
            changeClosed(id);
            return 0;
        }
        const openHour = Number(dayTime.slice(0, 2));
        const openMinute = Number(dayTime.slice(3, 5));
        const closeHour = Number(dayTime.slice(-5, -3));
        const closeMinute = Number(dayTime.slice(-2));

        console.log(id);
        console.log('현재', nowHour, nowMinutes, nowDay);
        console.log(openHour, openMinute, closeHour, closeMinute);


        if (openHour > nowHour){ 
            changeClosed(id);
            console.log('끝1');
        }else if(openHour == nowHour){
            if (openMinute > nowMinutes){
                changeClosed(id);
                console.log('끝2');
            }else{
                changeOpen(id);
                console.log('시작1');
            }
        }else if((openHour < nowHour) && (closeHour > nowHour)){
            changeOpen(id);
            console.log('시작2');
        }else if(closeHour == nowHour){
            if (closeMinute > nowMinutes){
                changeOpen(id);
                console.log('시작3');
            }else{
                changeClosed(id);
                console.log('끝3');
            }
        }else if (closeHour < nowHour){
            changeClosed(id);
            console.log('끝4');
        }        
    }catch (error){
        console.log(error);
        throw error;
    }
};

const makeSchedule = async (id) => {
    try{
        const restrtRef = fbDB.collection('restaurants').doc(id);
        const restrtSnapshot = await restrtRef.get();
        const timeList = restrtSnapshot.data().opening_hours; //월화수목금토일

        //자정마다 order number 초기화
        const initOrderNumber = schedule.scheduleJob(`00 00 15 * * *`, function () {
            changeOrderNumber(id);
            console.log(`${id}식당 order number init`);
        });

        //영업시간 스케줄러
        let i = 1;
        for (let day of timeList){ //월화수목금토일 
            if(day != "휴무"){
                const weekday = Number(i); //스케쥴: 일월화수목금토일
                const openHour = Number(day.slice(0, 2));
                const openMinute = Number(day.slice(3, 5));
                const closeHour = Number(day.slice(-5, -3));
                const closeMinute = Number(day.slice(-2));

                const openRule = new schedule.RecurrenceRule();
                if(openHour-9 >= 0){ //양수
                    openRule.hour = openHour-9;
                    openRule.dayOfWeek = weekday;
                }else{ //음수
                    openRule.hour = openHour-9+24;
                    openRule.dayOfWeek = weekday-1;
                }
                if(openRule.dayOfWeek == 7){openRule.dayOfWeek=0;}
                openRule.minute = openMinute;
                schedule.scheduleJob(openRule, function () {
                    changeOpen(id);
                    console.log(`${id}식당, ${openHour}시, ${openMinute}분 ${weekday}요일 open `);
                });

                const closeRule = new schedule.RecurrenceRule();
                if(closeHour-9 >= 0){ //양수
                    closeRule.hour = closeHour-9;
                    closeRule.dayOfWeek = weekday;
                }else{ //음수
                    closeRule.hour = closeHour-9+24;
                    closeRule.dayOfWeek = weekday-1;
                }
                closeRule.minute = closeMinute;
                if(closeRule.dayOfWeek == 7){closeRule.dayOfWeek=0;}
                schedule.scheduleJob(closeRule, function () {
                    changeClosed(id);
                    console.log(`${id}식당, ${closeHour}시, ${closeMinute}분 ${weekday}요일 close `);
                });
            }else{
            }
            i++;
        }
    }catch(error){
        console.log(error);
        throw error;
    }
};

const init = async ()=>{
    try{
        const restRef = fbDB.collection('restaurants');
        const snapshot = await restRef.get();
        const idList = [];
        snapshot.forEach(doc => {
            idList.push(doc.id);
        });
        for(let id of idList){
            //음식점 상태 변경
            await changeState(id);
            //스케줄 생성
            await makeSchedule(id);
        }
    }catch(error){
        console.log(error);
        throw error;
    }
}

export {
    changeOpen,
    changeClosed,
    changeState,
    changeOrderNumber,
    makeSchedule,
    init,
}