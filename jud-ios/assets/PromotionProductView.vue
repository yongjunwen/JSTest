<!--专属优惠商品卡片视图-->
<template>

    <div class="slider-item">
        <div class="topItemBg">
            <image class="topItemBgImage" :src="itemProduct.topPic"></image>
            <div class="topItemContent">
                <image style="width:212px;height: 70px;background-color: aquamarine " :src="itemProduct.brandLogo"></image>
                <text class="topItemContentText">[加入我们，创建未来]</text>
            </div>
        </div>

        <text class="text">{{itemProduct.name}}</text>
        <image class="bottom-image" :src="itemProduct.pic"></image>
    </div>
</template>

<style>
    .slider-item {
        /*margin-top: 100px;*/
        /*margin-bottom: 100px;*/
        /* margin-bottom: 10px;
         margin-left: 20px;
         margin-right: 20px;*/

        width: 600px;
        height: 946px;
        /*flex: auto;*/
        background-color: red;
        border-radius: 10px;
        overflow:hidden;
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
        height: 650px;
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

    .topItemContentText {
        /*margin-top: 30px;*/
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 20px;
        /*height: 40px;*/
        color: white;
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
        }
    }
</script>