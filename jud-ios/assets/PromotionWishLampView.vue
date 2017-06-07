<!--心愿灯卡片-->
<template>

    <div class="slider-item-wish_lamp">
        <div class="topItemContent">
            <text class="topItemContentText">心愿灯</text>
            <text class="lineItem">-·-</text>
            <text class="tipContent">{{tipContent}}</text>
        </div>
        <div class="contentDiv">
            <div>
                <image></image>
            </div>
        </div>
        <!--<text class="text">{{wishLampObject.name}}</text>-->
        <!-- <image class="image" :src="wishLampObject.pic"></image> -->
    </div>
</template>

<style>
    .slider-item-wish_lamp {

        /*margin-top: 100px;*/
        /*margin-bottom: 100px;*/
        width: 600px;
        height: 910px;
        border-radius: 10px;
        overflow: hidden;
        /*background-color: rgba(48, 131, 248, 0.7);*/
        background-color: rgb(48, 131, 248);
    }

    .topItemContent {
        top: 0;
        /*background-color: darkred;*/
        width: 600px;
        align-items: center;
        justify-content: center;
        position: absolute;
    }

    .lineItem {
        margin-top: 18px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 26px;
        /*height: 40px;*/
        color: white;
    }

    .topItemContentText {
        margin-top: 38px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 40px;
        /*height: 40px;*/
        color: white;
    }

</style>

<script>
    export default {
        data: {
            cardTitle: "心愿灯",
            tipContent: '30天内努力为你备好，请持续关注'
        },
        props: {
            wishLampObject: {
                type: Object,
                default: {}
            },
        }
    }
</script>