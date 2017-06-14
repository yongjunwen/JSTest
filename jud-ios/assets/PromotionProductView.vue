<!--专属优惠商品卡片视图-->
<template>

    <div class="rootDiv" :style="{height:brandRootHeight,width:brandItemWidth}">

        <div class="slider-item" :style="{height:brandItemHeight,width:brandItemWidth}">
            <div class="topItemBg" :style="{height:topItemBgHeight,width:brandItemWidth}">
                <image class="topItemBgImage" :src="itemProduct.topPic"
                       :style="{height:topItemBgHeight,width:brandItemWidth}"></image>
                <div class="topItemContent" :style="{width:brandItemWidth}">
                    <image style="width:212px;height: 70px;background-color: aquamarine ; margin-top: 18px;"
                           :style="{height:brandLogoHeight,width:brandLogoWidth}"
                           :src="itemProduct.brandLogo"></image>
                    <text class="lineItem">-·-</text>
                    <text class="topItemContentText">{{topContentText}}</text>
                </div>

                <!--弧度样式视图图层-->
                <div class="curveImageBg" :style="{height:brandItemCurveHeight,width:brandItemWidth}">
                    <image class="curveImage" :src="curveImage"
                           :style="{height:brandItemCurveHeight,width:brandItemWidth}"></image>
                </div>
            </div>

            <image class="bottom-image" :src="itemProduct.pic"
                   :style="{height:brandItemBottomImageHeight,width:brandItemWidth}"></image>

        </div>
        <div class="bottomDiv" style="justify-content: center; align-items: center;"
             :style="{width:brandItemWidth}">
            <text class="wishText">{{itemProduct.name}}</text>
            <div class="seeDiv"
                 @click="toSeeClick()">
                <!--<text class="seeText">{{seeContent}}</text>-->
                <image style="width:216px;height: 76px ;"
                       :src="seeButtonImage"></image>
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
        /*border-top-left-radius: 10px;*/
        /*border-top-right-radius: 10px;*/
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
    .curveImageBg {
        bottom:0;
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
        /*background-color: #db74c9;*/
        /*border-radius: 40px;*/
        /*overflow: hidden;*/
        height: 76px;
        width: 216px;
        justify-content: center;
        align-items: center;
    }

    .seeText {
        color: white;
        font-size: 22px;
    }
</style>

<script>
    import Util from './PromotionUtil.js'
    export default {
        data: function () {
            return {
                seeContent: '进去看看',
                curveImage: 'promotion_rectagle_icon.png',
                brandRootHeight: 0,
                brandItemHeight: 0,
                brandItemWidth: 0,
                topItemBgHeight: 0,
                brandLogoHeight: 0,
                brandLogoWidth: 0,
                brandItemBottomImageHeight: 0,

                brandItemCurveHeight: 0,
                seeButtonImage: 'see_button.png',
                topContentText: '[加入我们，创建未来]'
            }
        },
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
        },
        created: function () {
            this.brandRootHeight = Util.getSliderHeight(this);
            this.brandItemHeight = Util.getBrandItemHeight(this);
            this.brandItemWidth = Util.getBrandItemWidth(this);
            this.topItemBgHeight = Util.getBrandItemTopBgHeight(this);

            this.brandItemCurveHeight = Util.getBrandItemCurveHeigh(this);

            this.brandLogoHeight = Util.getBrandLogoHeight(this);
            this.brandLogoWidth = Util.getBrandLogoWidth(this);

            this.brandItemBottomImageHeight = Util.getBrandBottomImageHeight(this);
        }
    }
</script>