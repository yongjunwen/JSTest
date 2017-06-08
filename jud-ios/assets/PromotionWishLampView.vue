<!--心愿灯卡片-->
<template>

    <div class="rooDiv">
        <!--todo:背景图片待添加-->
        <div class="bgImageDiv">
            <image class="bgImage" :src="wishLampBg"></image>
        </div>
        <!--内容显示区域-->
        <div class="contentDiv">
            <!--头部区域元素-->
            <div class="topItemContent">
                <div style="align-items: center;justify-content: center;">
                    <text class="topItemContentText">{{cardTitle}}</text>
                    <text class="lineItem">-·-</text>
                    <text class="tipContent">{{tipContent}}</text>
                </div>
            </div>
            <!--灯笼显示区域 按行排列-->
            <div style="flex-direction: row; margin-left: 62px">

                <!--第一组：上下排列方式-->
                <div style="background-color: white ;margin-top: 60px;">
                    <promotion-wish-lamp-item-view></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view
                            style="margin-top: 50px;"></promotion-wish-lamp-item-view>

                </div>

                <!--第二组：上下排列方式-->
                <div style="background-color: yellow;;margin-top: 120px; margin-left: 43px;">
                    <promotion-wish-lamp-item-view></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view
                            style="margin-top: 50px;"></promotion-wish-lamp-item-view>

                </div>

                <!--第三组：上下排列方式-->
                <div style="background-color: yellow;;margin-top: 30px; margin-left: 43px;">
                    <promotion-wish-lamp-item-view></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view
                            style="margin-top: 50px;"></promotion-wish-lamp-item-view>

                </div>
            </div>

            <!--底部文案区域-->
            <div class="bottom" style="align-items: center;justify-content: center">
                <div>
                    <text class="bottomTipContent">{{bottomTipContent}}</text>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
    .rooDiv {

        /*margin-top: 100px;*/
        /*margin-bottom: 100px;*/
        width: 610px;
        height: 950px;
        border-radius: 10px;
        overflow: hidden;
        /*background-color: rgba(48, 131, 248, 0.7);*/
        /*background-color: rgb(48, 131, 248);*/
    }

    .bgImage {
        width: 610px;
        height: 950px;
    }

    .topItemContent {
        /*top: 0;*/
        /*background-color: darkred;*/
        width: 600px;
        /*position: absolute;*/
    }

    .topItemContentText {
        margin-top: 56px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 40px;
        /*height: 40px;*/
        color: white;
    }

    .lineItem {
        margin-top: 22px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 26px;
        /*height: 40px;*/
        color: white;
    }

    .tipContent {
        margin-top: 34px;
        color: white;
        font-size: 26px;
    }

    .contentDiv {
        /*background-color: rosybrown;*/
        position: absolute;
        top: 0;
    }

    .bottomTipContent {
        margin-top: 40px;
        color: white;
        font-size: 26px;
    }

</style>

<script>
    import PromotionWishLampItemView from './PromotionWishLampItemView.vue'
    export default {
        components: {
            PromotionWishLampItemView
        },
//        vue子视图引用的话data要写成如下方法样式
        data: function () {
            return {
                cardTitle: "心愿灯",
                wishLampBg: "wish_lamp_bg_image.png",
                tipContent: '30天内努力为你备好，请持续关注',
                bottomTipContent: '每天仅有有1次许愿机会'
            }
        },
        props: {
            wishLampObject: {
                type: Object,
                default: {}
            },
        }
    }
</script>