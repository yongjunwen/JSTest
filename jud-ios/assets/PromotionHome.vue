<template>
    <!-- 滑动组件的大背景视图 -->
    <!--  -->
    <div class="rootDiv" v-if="productList.length != 0">
        <div class="bgView" :style="{height:deviceHeight}">
            <image class="bgImage" :src="bgImage" :style="{height:deviceHeight}"
                   placeholder='native://slider_bg_image'></image>
        </div>

        <!-- :style="{height:deviceHeight}"-->
        <div class="contentView" :style="{height:deviceHeight,top:contentTop}">
            <slider-neighbor class="slider-neighbor" neighborAlpha="0.9"
                             :neighborSpace="neighborSpace" neighborScale="0.9" currentItemScale="1"
                             :index="selectIndex" @change="changeEvent" :style="{height:sliderHeight}">

                <!--:style="{backgroundColor:'#EE7A22'}"-->
                <div v-for="(itemProduct,index) in productList" :style="{height:sliderHeight,width:brandItemBgWidth}"
                     style="align-items: center;justify-content: center;">

                    <promotion-product-view
                            :itemProduct="itemProduct"
                            v-on:kClickBrand="clickBrandEvent(index)"
                            v-if="itemProduct.itemStyle==1"
                    ></promotion-product-view>

                    <promotion-wish-lamp-view :wishLampObject="itemProduct"
                                              v-if="itemProduct.itemStyle==2"
                    ></promotion-wish-lamp-view>
                </div>

            </slider-neighbor>
            <!-- 底部按钮背景视图 -->
            <div class="bottomTab" :style="{height:bottomTabHeight}" v-if="productList.length > 1">
                <!--<div v-for="(item,index) in productList" >-->
                <!--<promotion-bottom :item="item" :index="index" v-if="item"></promotion-bottom>-->
                <!--</div>-->
                <div class="bottomTabContentBg" :style="{height:bottomTabHeight,borderRadius:borderRadius}">

                    <div class="bottomTextBgDiv" v-for="(itemProduct,index) in productList"
                         :style="{'backgroundColor':(index==selectIndex?buttonBgSelectColor:buttonBgColor), height:bottomTabHeight,width:bottomTextWidth}"

                         @click="buttonClick(index)">
                        <!--<text class="bottomText">{{itemProduct.tabName}}</text>-->
                        <image class="bottomTabImage" :src="itemProduct.btmLogo"
                               :style="{height:bottomTabImageHeight,width:bottomTabImageWidth}"></image>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
    import PromotionBottom from './PromotionBottom.vue'
    import PromotionProductView from './PromotionProductView.vue'
    import PromotionWishLampView from './PromotionWishLampView.vue'
    import Util from './PromotionUtil.js'
    import bus from './PDBus.vue'
    var communicate = jud.requireModule('communicate');
    var mta = jud.requireModule('mta');

    const modal = jud.requireModule('modal');
    export default {
//        组件注册
        components: {
            PromotionProductView,
            PromotionWishLampView,
            PromotionBottom
        },
//        数据
        data: {
            test: 'test222',
            encodedActivityId: null,
            isHaveLightened: false,
            contentTop: 0,
            selectIndex: 0,
            neighborSpace: 0,
            brandItemBgWidth: 0,
            buttonBgSelectColor: "#000000",
            deviceHeight: 10,
            sliderHeight: 0,

            bottomTabHeight: 0,
            bottomTextWidth: 0,

            bottomTabImageHeight: 0,
            bottomTabImageWidth: 0,
            buttonBgColor: null,
            borderRadius: 0,

            wishLampCopy: null,
//            bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
            bgImage: 'slider_bg_image.png',
            productList: [],
        },
//        方法
        methods: {

            //底部tab按钮点击事件
            buttonClick: function (index) {
                this.selectIndex = index;
                this.addTabSelectMta(index);
            },

            addTabSelectMta: function (index) {
                //埋点
//                page_id_param_event_id_param_next
//               分别是： pageName,pageId,pageParam,eventName,eventId,eventParam,nextPageName
                var item = this.productList[index];
                var srv = item.srv; //todo:底部tab相应的srv ？
                mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "",
                    "addTabSelectMta", "CustomMade_ActCardFooter", srv, "");
            },
            addCardSlideMta: function (index) {
                var item = this.productList[index];
                var srv = item.srv;
                mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "",
                    "addCardSlideMta", "CustomMade_ActCardSlide", srv, "");
            },
            // 滑动组件change事件
            changeEvent: function (e) {
                var selectIndexStr = e["index"];

//                modal.toast({
//                    message: selectIndexStr,
//                    duration: 1.8
//                })

                this.selectIndex = Number(selectIndexStr);
                //添加滑动埋点
                this.addCardSlideMta(selectIndexStr);
            },

            /*
             获取品牌列表和心愿灯列表的网络请求
             预发：http:// beta-api.m.jd.com/client.action
             */
            fetchList: function () {
                var _this = this;
//                var reqBody = new Dictionary();
//                dictionary.set('encodedActivityId', "47fWAZihZPCoKesZmyPrDD8QokKG");
                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "request",
                        "info": "qryExclusiveDiscount",
                        "params": {
                            "functionId": "qryExclusiveDiscount",
                            "body": null
                        }
                    },
                    function (result) {
                        var str = JSON.stringify(result);
                        console.log('qryExclusiveDiscount-backData:' + str);
                        console.log('qryExclusiveDiscount-backData:' + result.toString());
                        console.log('qryExclusiveDiscount-backData-code:' + result.code);
                        if (String(result.code) === '0') {

                            _this.encodedActivityId = result.encodedActivityId;
//                            页面大背景图
                            _this.bgImage = result.head.bgPic;
//                            心愿灯上部文案是wishLampCopy
                            _this.wishLampCopy = result.head.wishLampCopy;
                            //1、如果品牌列表有数据
                            var _proList = result.brands;
                            if (_proList.length) {

                                _this.productList = _proList.slice(0, 4);
                                _this.productList.forEach(function (item, index) {
                                    console.log('forEach=' + item['brandId'])
                                    if (typeof item.itemStyle == 'undefined') {
                                        console.log('注册中 =====');
                                        //全局注册
                                        Vue.set(item, "itemStyle", "1");
                                    }
                                });
                            }

                            //2、如果心愿灯列表有数据
                            var _wishLamps = result.wishLamps;
                            if (_wishLamps.length) {
                                console.log('心愿灯=======有货');
//                           lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
//                           1、 首先遍历出是否已经点亮的逻辑
                                for (var i = 0; i < _wishLamps.length; i++) {
                                    var wishItem = _wishLamps[i];
                                    if (wishItem.lightened) {
                                        _this.isHaveLightened = true;
                                        console.log('第一次获取心愿灯=======已经存在点亮');
                                        break;
                                    }
                                }
//                            2、从上面的是否点亮逻辑来重新添加规划属性
                                _wishLamps.forEach(function (item, index) {
                                    if (typeof item.lampState == 'undefined') {
                                        console.log('lampState =====');

                                        var stateString = '1';
                                        if (_this.isHaveLightened) {
                                            if (item.lightened) {
                                                stateString = '2';
                                            } else {
                                                stateString = '3';
                                            }
                                        } else {
                                            stateString = '1';
                                        }

                                        //全局注册
                                        Vue.set(item, "lampState", stateString);
                                    }

                                });

                                var wishLampDict = {
                                    'itemStyle': '2',
                                    'btmLogo': "/img/wish_lamp_bottom_icon.png",
                                    'tabName': "心愿灯",
                                    'wishLampCopy': _this.wishLampCopy,
                                    'brandList': _wishLamps
                                };

                                console.log('_wishLamps=======已添加');
                                _this.productList.push(wishLampDict);
                            }

                        } else {
                            console.log('code非0返回状态======sendErrorToNative');
                            _this.sendErrorToNative();
                        }

                        //返回成功但是暂无数据情况
                        if (_this.productList.length == 0) {
                            console.log('返回成功但是暂无数据情况=======sendErrorToNative');
                            _this.sendErrorToNative();
                        }

                    });
            },

            //点击品牌跳转到详情页面事件
            clickBrandEvent: function (index) {
                console.log('clickBrandEvent=====jumpToBrand');
                //需要传给详情页面的入参
                var materialIds = [];
                for (var i = 0; i < this.productList.length; i++) {
                    var item = this.productList[i];
                    if (item.itemStyle == '1') {
                        materialIds.push(item.materialId);

                    }
                }

                console.log('clickBrandEvent=====');
//                var dictionary = new Dictionary();
//                dictionary.set('selectIndex', index);
//                dictionary.set('materialIds', materialIds);
//                dictionary.set('activityId', this.activityId);

//                发送到原生去跳转到详情
                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "jump",
                        "info": "toBrandDetail",
                        "params": {
                            "body": {
                                'selectIndex': index,
                                'materialIds': materialIds,
                                'encodedActivityId': this.encodedActivityId
                            }
                        }
                    },
                    function (result) {

                    });
//添加跳转到原生的埋点
//                page_id_param_event_id_param_next
//               分别是： pageName,pageId,pageParam,eventName,eventId,eventParam,nextPageName
                var item = this.productList[index];
                var srv = item.srv;
                mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "", "点击品牌到详情事件", "CustomMade_ActCard", srv, "");
            },
//            发送错误信息到native
            sendErrorToNative: function () {
                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "error",
                        "info": "qryExclusiveDiscount",
                        "params": null
                    },
                    function (result) {
                    });
            },
        },
//        生命周期created函数 不要写在metods体内
        created: function () {
            //
            var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
            var deviceHeight = this.$getConfig().env.deviceHeight;
            var deviceWidth = this.$getConfig().env.deviceWidth;

            console.log("*==deviceHeight=" + deviceHeight + "==deviceWidth=" + deviceWidth);

//            获取屏幕布局高度
            var height = Util.getHeight(this);//750 / deviceWidth * deviceHeight;
//            var testheight = Util.getHeight(this);
            console.log('deviceHeight=' + deviceHeight, 'viewH=' + height);

            var sliderH = Util.getSliderHeight(this);

            this.sliderHeight = sliderH;

//            设备类型匹配
            if (platform === "ios") {
//                height -= 5;
                this.contentTop = 210;
                console.log("=匹配到=iOS")
            } else if (platform === "android") {
                height -= 5;
                console.log("=匹配到=Android")
                this.contentTop = 180;
            } else {
                console.log("=没有匹配到=")
            }
            this.deviceHeight = height;

            console.log("*==处理后" + this.deviceHeight + "height=" + height + "platform=" + platform)

            this.bottomTabHeight = Util.scale(this) * 90;
            this.bottomTextWidth = Util.scale(this) * 130;
            this.bottomTabImageHeight = Util.scale(this) * 70;
            this.borderRadius = this.bottomTabHeight / 2;
            this.bottomTabImageWidth = Util.scale(this) * 100;

            var _nSpace = 55;
            if (platform === "android") {
                _nSpace = 30;
            }
            this.neighborSpace = Util.scale(this) * _nSpace;
            this.brandItemBgWidth = Util.scale(this) * 606;


            // 添加网络请求逻辑
            this.fetchList();
        },
        destroyed: function () {
            //页面销毁调用事件
            console.log("destroyed-=========");
        }
    }
</script>

<style scoped>

    .rootDiv {
        /*background-color: yellow;*/
    }

    .bgView {
        width: 750px;
        /*height: 1000px;*/
    }

    .bgImage {
        width: 750px;
        /*height: 1000px;*/
    }

    .contentView {
        /*头部留够导航高度间距*/
        /*top: 180px;*/
        position: absolute;
        width: 750px;
        /*justify-content: center;*/
    }

    .slider-neighbor {
        top: 0;
        /*margin-top: 10px;*/
        /*width: 750px;*/
        /*mark：高度一定要设置数字否在 android上显示不出来*/
        /*height: 940px;*/
        /*width: 320px;*/
        /*height: 280px;*/
        /*border-width: 1px;*/
        /*border-style: solid;*/
        /*border-color: #41B883;*/
        justify-content: center;
        align-items: center;
        /*background-color: #41B883;*/
    }

    .bottomTab {
        margin-top: 40px;
        /*width: 750px;*/
        /*height: 90px;*/
        /*border-width: 1px;*/
        /*border-style: solid;*/
        /*border-color: green;*/
        /*background-color: darkred;*/
        /*flex-direction: row;*/
        justify-content: center;
        align-items: center;

    }

    .bottomTabContentBg {
        background-color: rgba(0, 0, 0, 0.3);
        flex-direction: row;
        padding-left: 15px;
        padding-right: 15px;
        border-radius: 40px;
        overflow: hidden;
    }

    .bottomTextBgDiv {
        /*width: 130px;*/
        /*height: 90px;*/
        align-items: center;
        justify-content: center;
        /*background-color: red;*/
        /*border-radius: 20px;*/
    }

    .bottomText {
        /*background-color: white;*/
        /*  width: 60px;
        height: 40px;*/
        /*margin-left: 0;*/
        font-size: 22px;
        color: white;
        /*text-align: center;*/
    }

</style>