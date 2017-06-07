<!--专属优惠商品卡片视图-->
<template>

    <div class="rootDiv">

        <div class="slider-item">
            <div class="topItemBg">
                <image class="topItemBgImage" :src="itemProduct.topPic"></image>
                <div class="topItemContent">
                    <image style="width:212px;height: 70px;background-color: aquamarine ; margin-top: 18px;"
                           :src="itemProduct.brandLogo"></image>
                    <text class="lineItem">-·-</text>
                    <text class="topItemContentText">[加入我们，创建未来]</text>
                </div>
            </div>

            <image class="bottom-image" :src="itemProduct.pic"></image>

        </div>
        <div class="bottomDiv" style="justify-content: center; align-items: center;">
            <text class="wishText">{{itemProduct.name}}</text>
            <div class="seeDiv"
                 @click="toSeeClick()">
                <text class="seeText">进去看看</text>
            </div>

        </div>
    </div>
</template>

<style>
    .rootDiv {
        width: 600px;
        height: 940px;
    }
    .slider-item {
        /*margin-top: 100px;*/
        /*margin-bottom: 100px;*/
        /* margin-bottom: 10px;
         margin-left: 20px;
         margin-right: 20px;*/

        width: 600px;
        height: 910px;
        background-color: white;
        border-radius: 10px;
        overflow: hidden;
    }

    .topItemBg {
        width: 600px;
        height: 260px;
    }

    .topItemBgImage {
        width: 600px;
        height: 260px;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
    }

    .bottom-image {
        /*top: 300px;*/
        margin-left: 0;
        margin-right: 0;
        width: 600px;
        height: 550px;
        /*resize: stretch;*/
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
        margin-top: 18px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 26px;
        /*height: 40px;*/
        color: white;
    }

    .bottomDiv {
        bottom: 0;
        /*background-color: darkred;*/
        width: 600px;
        align-items: center;
        justify-content: center;
        position: absolute;
    }
    .wishText {
        font-size: 25px;
        color: #333333;
    }

    .seeDiv {
        margin-top: 10px;
        background-color: #db74c9;
        border-radius: 40px;
        overflow: hidden;
        height: 60px;
        width: 200px;
        justify-content: center;
        align-items: center;
    }

    .seeText {
        color: white;
        font-size: 22px;
    }
</style>

<script>
    export default {
        data: {},
        props: {
            itemProduct: {
                type: Object,
                default: {}
            },
        },
        methods: {
            toSeeClick: function () {
                console.log('--------toSeeClick----+++')
            }
        }
    };
</script>