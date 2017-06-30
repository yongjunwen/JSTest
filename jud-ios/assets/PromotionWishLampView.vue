<!--心愿灯卡片-->
<template>

    <div class="rooDiv" :style="{height:wishRootHeight,width:wishRootWidth}">
        <!--todo:背景图片待添加-->
        <div class="bgImageDiv">
            <!-- placeholder="native://wish_lamp_bg_placeholder" 暂时放弃-->
            <image class="bgImage" :src="wishLampBg" :style="{height:wishRootHeight,width:wishRootWidth}"
            ></image>
        </div>
        <!--内容显示区域-->
        <div class="contentDiv">
            <!--头部区域元素-->
            <div class="topItemContent" :style="{width:wishRootWidth}">
                <div style="align-items: center;justify-content: center;">
                    <text class="topItemContentText" :style="{fontSize:titleFontSize,marginTop:titleTop}">{{cardTitle}}</text>
                    <!--<text class="lineItem">-·-</text>-->
                    <image class="seperateicon" :src="seperateicon"></image>
                    <text class="tipContent" :style="{fontSize:contentFontSize,marginTop:contentTop}">{{wishLampObject.wishLampCopy}}</text>
                </div>
            </div>
            <!--灯笼显示区域 按行排列-->
            <div style="flex-direction: row;">
                <!--v-for="lampItem in wishLampObject.brandList"-->
                <!--第一组：上下排列方式-->
                <div style="margin-left: 15px;" :style="{marginTop:marginTop1}">
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[0]"
                                                   :wishLampItem="wishLampObject.brandList[0]"
                                                   v-on:changeLampState='changeLampStateEvent'
                    ></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[3]"
                                                   style="margin-top: 26px;"
                                                   :wishLampItem="wishLampObject.brandList[3]"
                                                   v-on:changeLampState='changeLampStateEvent'
                    ></promotion-wish-lamp-item-view>

                </div>

                <!--第二组：上下排列方式-->
                <div style="margin-top: 120px; margin-left: -20px;" :style="{marginTop:marginTop2}">
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[1]"
                                                   :wishLampItem="wishLampObject.brandList[1]"
                                                   v-on:changeLampState='changeLampStateEvent'
                    ></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[4]"
                                                   style="margin-top: 26px;"
                                                   :wishLampItem="wishLampObject.brandList[4]"
                                                   v-on:changeLampState='changeLampStateEvent'></promotion-wish-lamp-item-view>

                </div>

                <!--第三组：上下排列方式-->
                <div style=";margin-top: 30px; margin-left: -20px;" :style="{marginTop:marginTop3}">
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[2]"
                                                   :wishLampItem="wishLampObject.brandList[2]"
                                                   v-on:changeLampState='changeLampStateEvent'></promotion-wish-lamp-item-view>
                    <promotion-wish-lamp-item-view v-if="wishLampObject.brandList[5]"
                                                   style="margin-top: 26px;"
                                                   :wishLampItem="wishLampObject.brandList[5]"
                                                   v-on:changeLampState='changeLampStateEvent'></promotion-wish-lamp-item-view>

                </div>
            </div>
        </div>
        <!--底部文案区域-->
        <div class="bottom" style="width: 610px" :style="{width:wishRootWidth}">
            <div style="align-items: center;justify-content: center;">
                <text class="bottomTipContent">{{bottomTipContent}}</text>
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
        margin-top: 45px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 40px;
        /*height: 40px;*/
        color: #ffffff;
    }

    .lineItem {
        margin-top: 22px;
        /*margin-left: 10px;*/
        /*margin-right: 10px;*/
        font-size: 26px;
        /*height: 40px;*/
        color: white;
    }

    .seperateicon {
        margin-top: 22px;
        height: 8px;
        width: 60px;
    }

    .tipContent {
        margin-top: 34px;
        color: #ffffff;
        font-size: 26px;
        lines: 1;
        text-overflow: ellipsis;
    }

    .contentDiv {
        /*background-color: rosybrown;*/
        position: absolute;
        top: 0;
    }

    .bottom {
        position: absolute;
        bottom:80px;
        /*margin-bottom: 10px;*/
        /*background-color: #EE7A23;*/
    }

    .bottomTipContent {
        margin-top: 1px;
        color: white;
        font-size: 22px;
        lines: 1;
        text-overflow: ellipsis;
    }

</style>

<script>
    import PromotionWishLampItemView from './PromotionWishLampItemView.vue'
    import Util from './PromotionUtil.js'
    var communicate = jud.requireModule('communicate');
    export default {
        components: {
            PromotionWishLampItemView
        },
//        vue子视图引用的话data要写成如下方法样式
        data: function () {
            return {
                wishRootHeight: 0,
                wishRootWidth: 0,

                titleFontSize: 0,
                titleTop: 0,

                contentFontSize: 0,
                contentTop: 0,

                marginTop1: 0,
                marginTop2: 0,
                marginTop3: 0,

                cardTitle: "心愿灯",
                seperateicon: '/img/promotion_seperation_icon.png',
                wishLampBg: "/img/wish_lamp_bg_image.png",
                tipContent: '30天内努力为你备好，请持续关注',
                bottomTipContent: '每天仅有有1次许愿机会'
            }
        },
        props: {
            wishLampObject: {
                type: Object,
                default: {}
            },
        },
        methods: {
            itemClick: function (index) {
                console.log('itemClick=====');
            },

//todo: 点亮心愿灯网络请求
            lightenBrandWishLampEvent: function (brandId) {
                var _this = this;
                console.log('lightenBrandWishLampEvent==brandId' + brandId);
                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "request",
                        "info": "lightenBrandWishLamp",
                        "params": {
                            "functionId": "lightenBrandWishLamp",
                            "body": {'brandId': brandId}
                        }
                    },
                    function (result) {

                        if (String(result.code) === '0') {
                            console.log("lightenBrandWishLampEvent------===请求成功");
                            //表示请求成功
//                            _this.updateLampData();
                            _this.wishLampObject.brandList.forEach(function (item, index) {
                                console.log('brandId=' + item['brandId'])
                                if (item['brandId'] === brandId) {
                                    item['lampState'] = '2';
                                    console.log('changeLampStateEvent====lampState=2');
                                } else {
                                    console.log('changeLampStateEvent====lampState=3');
                                    item['lampState'] = '3';
                                }
                            });

                        } else {
                            communicate.send("kBrandPromotionHomeCallBack",
                                {
                                    "domain": "error",
                                    "info": "lightenBrandWishLamp",
                                    "params": result
                                },
                                function (result) {
                                });
                        }
                    });
            },
            updateLampData: function () {
                console.log("updateLampData------===");
                this.wishLampObject.brandList.forEach(function (item, index) {
                    console.log('brandId=' + item['brandId'])
                    if (item['brandId'] === lampItemID) {
                        item['lampState'] = '2';
                        console.log('changeLampStateEvent====lampState=2');
                    } else {
                        console.log('changeLampStateEvent====lampState=3');
                        item['lampState'] = '3';
                    }
                });
            },
            changeLampStateEvent: function (lampItemID) {
                console.log('changeLampStateEvent=====' + lampItemID + '获取到');
                console.log('array=' + this.wishLampObject.brandList);

//                todo:添加点亮心愿灯网络请求逻辑
                this.lightenBrandWishLampEvent(lampItemID);
            }
        },
        created: function () {
            this.wishRootHeight = Util.getWishItemHeight(this);
            this.wishRootWidth = Util.getWishItemWidth(this);

            this.titleFontSize = 40 * Util.scale(this);
            this.titleTop = 65 * Util.scale(this);

            this.contentFontSize = 26 * Util.scale(this);
            this.contentTop = 34 * Util.scale(this);

            this.marginTop1 = 50 * Util.scale(this);
            this.marginTop2 = 100 * Util.scale(this);
            this.marginTop3 = 10 * Util.scale(this);
        }
    };
</script>