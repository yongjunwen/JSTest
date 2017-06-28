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
                <div v-for="(itemProduct,index) in productList">

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
            <div class="bottomTab" :style="{height:bottomTabHeight}">
                <!--<div v-for="(item,index) in productList" >-->
                <!--<promotion-bottom :item="item" :index="index" v-if="item"></promotion-bottom>-->
                <!--</div>-->
                <div class="bottomTabContentBg">

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
            buttonBgSelectColor: "#000000",
            deviceHeight: 10,
            sliderHeight: 0,

            bottomTabHeight: 0,
            bottomTextWidth: 0,

            bottomTabImageHeight: 0,
            bottomTabImageWidth: 0,
            buttonBgColor: null,

            wishLampCopy:null,
//            bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
            bgImage: 'slider_bg_image.png',
            productList: [],
//            productList: [
////                {
////                    itemStyle: "1",
////                    tabName: "魅族",
////                    btmLogo: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
////                    hitCopy: "您许的愿望已为您备好，魅族",
////                    logo: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
////                    topPic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
////                    middlePic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg"
////                },
//                {
//                    itemStyle: "1",
//                    tabName: "华为",
//                    btmLogo: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1496912449&di=1d908831b09e08208c79e53dce78fc73&src=http://pic.qiantucdn.com/58pic/12/38/18/13758PIC4GV.jpg",
//                    hitCopy: "您许的愿望已为您备好，华为",
//                    logo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
//                    topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
//                    middlePic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
//                },
//                {
//                    itemStyle: "1",
//                    tabName: "小米",
//                    btmLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497517343&di=baff522d5450339011176b5c1fea1302&imgtype=jpg&er=1&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_0_96973789D2128229081_23.jpg",
//                    hitCopy: "您许的愿望已为您备好，小米",
//                    logo: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1052774542,692148190&fm=26&gp=0.jpg",
//                    topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
//                    middlePic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
//                },
//                {
//                    itemStyle: "1",
//                    tabName: "魅族",
//                    btmLogo: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg",
//                    hitCopy: "您许的愿望已为您备好，魅族",
//                    logo: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg",
//                    topPic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
//                    middlePic: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg"
//                },
//                {
//                    itemStyle: "1",
//                    tabName: "格力",
//                    btmLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922663211&di=fd30c4a8b7b1ba325925c91cb2a32586&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F57%2F08%2F92G58PICHbX.jpg",
//                    hitCopy: "您许的愿望已为您备好，格力",
//                    logo: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=572491635,2679502336&fm=26&gp=0.jpg",
//                    topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/middlePic/2013-01-22/927_p56.jpg ",
//                    middlePic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
//                },
//                {
//                    tabName: "心愿灯",
//                    itemStyle: "2",
//                    btmLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg",
//                    hitCopy: "要降价!京东和阿里打价格战:刘强东发飙",
//                    middlePic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t1870/20/2688983380/490055/66145088/5715bc6aN4933b67c.jpg!q70.jpg",
//                    brandList: [{
//                        lampState: '1',
//                        brandId: '111',
//                        img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
//                    },
//                        {
//                            lampState: '1',
//                            brandId: '112',
//                            img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497517343&di=baff522d5450339011176b5c1fea1302&imgtype=jpg&er=1&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_0_96973789D2128229081_23.jpg'
//                        },
//                        {
//                            lampState: '1',
//                            brandId: '113',
//                            img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922663211&di=fd30c4a8b7b1ba325925c91cb2a32586&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F57%2F08%2F92G58PICHbX.jpg'
//                        },
//                        {
//                            lampState: '1',
//                            brandId: '114',
//                            img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
//                        },
//                        {
//                            lampState: '1',
//                            brandId: '115',
//                            img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
//                        },
//                        {
//                            lampState: '1',
//                            brandId: '116',
//                            img: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
//                        }
//                    ]
//                }
//            ]
        },
//        方法
        methods: {

            //底部tab按钮点击事件
            buttonClick: function (index) {
                this.selectIndex = index;
            },

            // 滑动组件change事件
            changeEvent: function (e) {
                var selectIndexStr = e["index"];

//                modal.toast({
//                    message: selectIndexStr,
//                    duration: 1.8
//                })

                this.selectIndex = Number(selectIndexStr);
                // if(this.selectIndex  == 0){
                //   this.selectIndex  = 1;
                // }else{
                //   this.selectIndex  = 0;
                // }
                console.log(e);
//                和原生端进行通信协议
                var nativeEventHandle = require('@jud-module/nativeEventHandle');

                var self = this;
//                nativeEventHandle.handleEvent(
//                    "kScrollChangeKey", //通信key
//                    {"index": e},
//                    function (ret) {
//                        // ret就是我们传入的{"Hello": "World"}
//                    });
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
                        console.log('qryExclusiveDiscount-backData:' + result);
                        console.log('qryExclusiveDiscount-backData-code:' + result.code);
                        if (String(result.code) === '0') {

                            _this.encodedActivityId = result.encodedActivityId;
//                            页面大背景图
                            _this.bgImage = result.head.bgPic;
//                            心愿灯上部文案是wishLampCopy
                            _this.wishLampCopy = result.head.wishLampCopy;
                            //todo:sample
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

                                var _wishLamps = result.wishLamps;

                                if (_wishLamps.length) {
                                    console.log('_wishLamps=======有货');
//                           lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
//                           1、 首先遍历出是否已经点亮的逻辑
//                                _wishLamps.forEach(function (item, index) {
//////                                    foreach不支持直接break
//                                });

                                    for (var i = 0; i < _wishLamps.length; i++) {
                                        var wishItem = _wishLamps[i];
                                        if (wishItem.lightened) {
                                            _this.isHaveLightened = true;
                                            console.log('_wishLamps=======break');
//                                        foreach.break = new Error("已点亮 跳出");

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
                                        'btmLogo': "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg",
                                        'tabName': "心愿灯",
                                        'wishLampCopy': _this.wishLampCopy,
                                        'brandList': _wishLamps
                                    };

                                    console.log('_wishLamps=======已添加');
                                    _this.productList.push(wishLampDict);
                                } else {
//返回成功但是暂无数据情况

                                    _this.sendErrorToNative();
                                }
                            }

                        } else {

                            _this.sendErrorToNative();
                        }


                    });
            },

            //点击品牌跳转到详情页面事件
            clickBrandEvent: function (index) {
                console.log('clickBrandEvent=====0hahahahahahah');
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

                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "jump",
                        "info": "toBrandDetail",
                        "params": {
                            "body": {'selectIndex':index,'materialIds':materialIds,'encodedActivityId':this.encodedActivityId}
                        }
                    },
                    function (result) {

                    });

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
            this.bottomTabImageWidth = Util.scale(this) * 100;

            var _nSpace = 55;
            if (platform === "android") {
                _nSpace = 30;
            }
            this.neighborSpace = Util.scale(this) * _nSpace;


            // 添加网络请求逻辑
            this.fetchList();
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
        /*justify-content: center;*/
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