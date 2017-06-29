<!--专属优惠商品卡片视图-->
<template>

    <div class="rootDiv" :style="{height:brandRootHeight,width:brandItemWidth}">

        <div class="slider-item" :style="{height:brandItemHeight,width:brandItemWidth}" @click="toSeeClick()">
            <div class="topItemBg" :style="{height:topItemBgHeight,width:brandItemWidth}">
                <image class="topItemBgImage" :src="itemProduct.titleAtmoPic" placeholder="native://zs_detail_brand_placeholder"
                       :style="{height:topItemBgHeight,width:brandItemWidth}"></image>
                <div class="topItemContent" :style="{width:brandItemWidth}">
                    <!--:src="itemProduct.logo"-->
                    <image style="width:212px;height: 70px; margin-top: 18px;"
                           :style="{height:brandLogoHeight,width:brandLogoWidth}"
                            placeholder="native://zs_detail_brand_placeholder"></image>
                    <!--<text class="lineItem">-·-</text>-->
                    <image class="seperateicon" :src="seperateicon"></image>
                    <!--添加括号信息-->
                    <div class='brandinfo'>
                        <div class="brandtexticon-p"></div>
                        <div class="brandtext-p">
                            <text class='brandtext'>{{itemProduct.name}}</text>
                            <text class='brandtext'>{{itemProduct.name}}</text>
                        </div>
                        <div class="brandtexticon-p"></div>
                        <image class='brandtexticonleft' :src="brandtexticonleft"></image>
                        <image class='brandtexticonright' :src="brandtexticonright"></image>
                    </div>
                    <!--<text class="topItemContentText">{{topContentText}}</text>-->
                </div>

                <!--弧度样式视图图层-->
                <div class="curveImageBg" :style="{height:brandItemCurveHeight,width:brandItemWidth}">
                    <image class="curveImage" :src="curveImage"  placeholder="native://promotion_rectagle_icon"
                           :style="{height:brandItemCurveHeight,width:brandItemWidth}"></image>
                </div>
            </div>

            <image class="bottom-image" :src="itemProduct.middlePic" placeholder="native://zs_detail_brand_placeholder"
                   :style="{height:brandItemBottomImageHeight,width:brandItemWidth}"></image>

        </div>
        <div class="bottomDiv" style="justify-content: center; align-items: center;"
             :style="{width:brandItemWidth}">
            <text class="wishText">{{itemProduct.hitCopy}}</text>
            <div class="seeDiv"
                 @click="toSeeClick()">
                <!--<text class="seeText">{{seeContent}}</text>-->
                <image style="width:216px;height: 76px ;"
                       :src="seeButtonImage" placeholder='native://see_button'></image>
            </div>

        </div>
    </div>
</template>

<style>
    .rootDiv {
        /*width: 600px;*/
        /*height: 940px;*/
    }

    .slider-item {
        /*width: 600px;*/
        /*height: 910px;*/
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

    .seperateicon {
        margin-top: 20px;
        height: 8px;
        width: 60px;
    }

    .curveImageBg {
        bottom: 0;
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

    .brandinfo {
        margin-top: 22px;
        flex-direction: row;
        margin-bottom: 50px;
    }

    .brandtext-p {
        flex: 0.8;
        max-width: 448px;
    }

    .brandtexticon-p {
        flex: 0.1;
        width: 39px;
    }

    .brandtext {
        font-size: 30px;
        color: #fff;
        max-width: 448px;
        text-align: center;
        vertical-align: center;
        padding-top: 0px;
    }

    .brandtexticonleft {
        position: absolute;
        width: 9px;
        height: 20px;
        left: 0px;
        top: 5px;
        margin-right: 20px;
    }

    .brandtexticonright {
        position: absolute;
        bottom: 0px;
        right: 0px;
        width: 9px;
        height: 20px;
        margin-left: 20px;
    }
</style>

<script>
    import Util from './PromotionUtil.js'
    var communicate = jud.requireModule('communicate');
    import bus from './PDBus.vue'
    export default {
        data: function () {
            return {
                seeContent: '进去看看',
                curveImage: 'promotion_rectagle_icon.png',
                seperateicon: 'zs_d_icon_05.png',
                brandRootHeight: 0,
                brandItemHeight: 0,
                brandItemWidth: 0,
                topItemBgHeight: 0,
                brandLogoHeight: 0,
                brandLogoWidth: 0,
                brandItemBottomImageHeight: 0,

                brandItemCurveHeight: 0,
                seeButtonImage: 'see_button.png',
                topContentText: '[加入我们，创建未来]',

//                brandtexticonleft: '/img/zs_d_icon_06_left.png',
//                brandtexticonright: '/img/zs_d_icon_06_right.png',
                brandtexticonleft: 'https://h5.m.jd.com/dev/36dSd8yihgQ6pgqyBubDq6e8yPtM/pages/76035/img/zs_d_icon_06_left.png',
                brandtexticonright: 'https://h5.m.jd.com/dev/36dSd8yihgQ6pgqyBubDq6e8yPtM/pages/76035/img/zs_d_icon_06_right.png'
            }
        },
        props: {
            itemProduct: {
                type: Object,
                default: {}
            },

            parentList: {
                type: Object,
                default: {}
            },

            activityId: {
                type: Object,
                default: {}
            },

            selectIndex: {
                type: Object,
                default: {}
            },
            clickBrandEvent: {
                type: Function,
            }
        },
        methods: {
            clickBrandEvent: function () {
                console.log('clickBrandEvent=====0');
                //需要传给详情页面的入参
                var materialIds = [];
                for (var i = 0; i < this.parentList.length; i++) {
                    var item = this.parentList[i];
                    if (item.itemStyle == '1') {
                        materialIds.push(item.materialId);

                    }
                }

                console.log('clickBrandEvent====='+ materialIds);
//                var dictionary = new Dictionary();
//                dictionary.set('selectIndex', index);
//                dictionary.set('materialIds', materialIds);
//                dictionary.set('activityId', this.activityId);

                communicate.send("kBrandPromotionHomeCallBack",
                    {
                        "domain": "jump",
                        "info": "toBrandDetail",
                        "params": {
                            "body": {'selectIndex':this.selectIndex,'materialIds':materialIds,'activityId':this.activityId}
                        }
                    },
                    function (result) {

                    });

            },
            toSeeClick: function () {
                console.log('--------toSeeClick----+++');
//                this.clickBrandEvent();
//                console.log(this.clickBrandEvent());
                this.$emit('kClickBrand');
//                 触发组件 A 中的事件
//                bus.$emit('id-selected', 1)
            }
        },
        created: function () {
            console.log("品牌卡片开始创建")
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