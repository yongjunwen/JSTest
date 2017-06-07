<template>
    <!-- 滑动组件的大背景视图 -->
    <!--  -->
    <div class="rootDiv">
        <div class="bgView" :style="{height:deviceHeight}">
            <image class="bgImage" :src="bgImage" :style="{height:deviceHeight}"></image>
        </div>

        <!-- :style="{height:deviceHeight}"-->
        <div class="contentView" :style="{height:deviceHeight}">
            <slider-neighbor class="slider-neighbor" neighborAlpha="0.9"
                             neighborSpace="55" neighborScale="0.9" currentItemScale="1"
                             :index="selectIndex" @change="changeEvent">

                <div @click="clickEvent" v-for="itemProduct in productList">

                    <promotion-product-view :itemProduct="itemProduct"
                                            v-if="itemProduct.itemStyle==1"></promotion-product-view>

                    <promotion-wish-lamp-view :wishLampObject="itemProduct"
                                              v-if="itemProduct.itemStyle==2"></promotion-wish-lamp-view>
                </div>

            </slider-neighbor>
            <!-- 底部按钮背景视图 -->
            <!-- :style='{backgroundColor: buttonBgColor} -->
            <div class="bottomTab">
                <!--<div v-for="(item,index) in productList" >-->
                <!--<promotion-bottom :item="item" :index="index" v-if="item"></promotion-bottom>-->
                <!--</div>-->
                <div class="bottomTabContentBg">

                    <div class="bottomTextBgDiv" v-for="(itemProduct,index) in productList"
                         v-bind:style="{'backgroundColor':(index==selectIndex?buttonBgSelectColor:buttonBgColor)}"
                         @click="buttonClick(index)">
                        <text class="bottomText">{{itemProduct.logoName}}</text>
                    </div>
                </div>
            </div>

        </div>
        <!--测试代码-->
        <!--<div class="test" style="align-items: center;-->
        <!--justify-content: center; background-color: aquamarine; width: 90px; height: 50px">-->
        <!--<text class="bottomText">测试</text>-->
        <!--</div>-->
    </div>
</template>

<script>
    import PromotionBottom from './PromotionBottom.vue'
    import PromotionProductView from './PromotionProductView.vue'
    import PromotionWishLampView from './PromotionWishLampView.vue'

    const modal = jud.requireModule('modal')
    export default {
        components: {
            PromotionProductView,
            PromotionWishLampView,
            PromotionBottom
        },
        data: {
            test: 'test222',
            selectIndex: 0,
            buttonBgSelectColor: "#000000",
            deviceHeight: 10,
            buttonBgColor: null,
            bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
            productList: [
                {
                    itemStyle: "1",
                    logoName: "华为",
                    name: "您许的愿望已为您备好，华为",
                    brandLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
                    topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
                    pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
                },
                {
                    itemStyle: "1",
                    logoName: "小米",
                    name: "您许的愿望已为您备好，小米",
                    brandLogo: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1052774542,692148190&fm=26&gp=0.jpg",
                    topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
                    pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
                },
                {
                    itemStyle: "1",
                    logoName: "格力",
                    name: "您许的愿望已为您备好，格力",
                    brandLogo: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=572491635,2679502336&fm=26&gp=0.jpg",
                    topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/pic/2013-01-22/927_p56.jpg ",
                    pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
                },
                {
                    logoName: "心愿灯",
                    itemStyle: "2",
                    name: "要降价!京东和阿里打价格战:刘强东发飙",
                    brandLogo: "",
                    pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t1870/20/2688983380/490055/66145088/5715bc6aN4933b67c.jpg!q70.jpg"
                }
            ]
        },
        methods: {

            buttonClick: function (index) {
                this.selectIndex = index;
            },

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
            }
        },
        created: function () {
            //
            var platform = this.$getConfig().env.platform;
//            获取设备高度
            var deviceHeight = this.$getConfig().env.deviceHeight;
            var deviceWidth = this.$getConfig().env.deviceWidth;

            var height = 750 / deviceWidth * deviceHeight;
            if (platform === "iOS") {
                height -= 20;
            } else if (platform === "Android") {
                height -= 120;
            } else {
                console.log("=没有匹配到=")
            }
            this.deviceHeight = height;
//                jud.config.deviceHeight;
            console.log("---------" + this.deviceHeight + "height=" + height + "platform=" + platform)
        }
    }
</script>

<style scoped>

    .rootDiv {
        background-color: yellow;
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
        top: 0;
        position: absolute;
        width: 750px;
        /*height: 1100px;*/
        /*mark：目前高度在android上拿到的不准备 设置center就会偏下*/
        justify-content: center;
    }

    .slider-neighbor {
        top: 0;
        /*margin-top: 10px;*/
        width: 750px;
        /*mark：高度一定要设置数字否在 android上显示不出来*/
        height: 940px;
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
        margin-top: 10px;
        /*width: 750px;*/
        height: 90px;
        /*border-width: 1px;*/
        /*border-style: solid;*/
        /*border-color: green;*/
        /*background-color: darkred;*/
        /*flex-direction: row;*/
        justify-content: center;
        align-items: center;
    }

    .bottomTabContentBg {
        background-color: rgba(0, 0, 0, 0.7);
        flex-direction: row;
        padding-left: 40px;
        padding-right: 40px;
        border-radius: 40px;
    }

    .bottomTextBgDiv {
        width: 130px;
        height: 90px;
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