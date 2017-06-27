<!--单个心愿灯卡灯笼视图-->
<template>
    <!--lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态-->
    <div class="rootDiv">
        <!--:style="{height:wishRootHeight,width:wishRootWidth}"-->
        <div class="lampItem" :style="{width:lampItemWidth}" @click="clickLampEvent()">

            <div class="lampIconBg" :style="{height:lampIconHeight,width:lampItemWidth}">
                <!--正常状态-->
                <image class="lampIcon" :src="lampPlaceHolderIcon"
                       :style="{height:lampIconHeight,width:lampItemWidth}"></image>
                <!--&lt;!&ndash;正常状态&ndash;&gt;-->
                <!--<image class="lampIcon" :src="wishLampNomalIcon" placeholder="native://wish_lamp_normal_icon"-->
                <!--:style="{height:lampIconHeight,width:lampItemWidth}" v-if="wishLampItem.lampState==1"></image>-->
                <!--&lt;!&ndash;点亮状态&ndash;&gt;-->
                <!--<image class="lampSelectIcon" :src="wishLampSelectIcon" placeholder="native://wish_lamp_select_icon"-->
                <!--:style="{height:lampIconHeight,width:lampItemWidth}" v-if="isShowSelect==true"></image>-->
                <!--&lt;!&ndash;变暗状态&ndash;&gt;-->
                <!--<image class="lampIcon" :src="wishLampDisableIcon" placeholder="native://wish_lamp_disable_icon"-->
                <!--:style="{height:lampIconHeight,width:lampItemWidth}" v-if="wishLampItem.lampState==3"></image>-->

                <div style="position: absolute;top: 0;justify-content: center;align-items: center;"
                     :style="{height:lampIconHeight,width:lampItemWidth}">
                    <image class="brandLogo"
                           :style="{opacity:brandLogoImageOpacity,height:brandLogoHeight,width:brandLogoWidth}"
                           :src="wishLampItem.img"></image>
                </div>
            </div>
            <div class="lampButtonBg" :style="{height:lampButtonBgHeight,width:lampItemWidth}">
                <image class="lampButtonIcon" :src="wishLampBtnIcon"
                       :style="{height:lampButtonBgHeight,width:lampButtonIconWidth}"></image>
                <!--<image class="lampButtonIcon" :src="wishLampNomalBtn" placeholder="native://wish_lamp_normal_btn"-->
                       <!--:style="{height:lampButtonBgHeight,width:lampButtonIconWidth}"-->
                       <!--v-if="wishLampItem.lampState==1"></image>-->

                <!--<image class="lampButtonIcon" :src="wishLampSelectBtn" placeholder="native://wish_lamp_select_btn"-->
                       <!--:style="{height:lampButtonBgHeight,width:lampButtonIconWidth}"-->
                       <!--v-if="wishLampItem.lampState==2"></image>-->

                <!--<image class="lampButtonIcon" :src="wishLampDisableBtn" placeholder="native://wish_lamp_disable_btn"-->
                       <!--:style="{height:lampButtonBgHeight,width:lampButtonIconWidth}"-->
                       <!--v-if="wishLampItem.lampState==3"></image>-->


                <div style="position: absolute;top: 0;justify-content: center;align-items: center;width: 132px;height: 46px"
                     :style="{height:lampButtonBgHeight,width:lampItemWidth}">
                    <text class="lanmpButtonText" :style="{color:lampTextColor}">{{lampText}}</text>
                </div>
            </div>
        </div>
    </div>
</template>

<style>


    .rootDiv {
        /*background-color: rosybrown;*/
    }

    .lampItem {
        /*background-color: darkred;*/
        /*width: 132px*/
    }

    .lampIconBg {
        /*width: 132px;*/
        /*height: 144px;*/
        justify-content: center;
        align-items: center;
    }

    .lampSelectIcon {

    }

    .lampIcon {
        /*width: 132px;*/
        /*height: 144px;*/
    }

    .brandLogo {
        background-color: rosybrown;
        width: 96px;
        height: 60px;

    }

    .lampButtonBg {
        /*margin-top: 14px;*/
        /*margin-left: 25px;*/
        width: 132px;
        height: 46px;
        justify-content: center;
        align-items: center;
    }

    .lampButtonIcon {
        width: 126px;
        height: 46px;
    }

    .lanmpButtonText {
        /*position: absolute;*/
        /*top: 0;*/
        color: white;
        font-size: 20px;
    }

</style>

<script>
    const modal = jud.requireModule('modal')
    import Util from './PromotionUtil.js'
    export default {
//        vue子视图引用的话data要写成如下方法样式
        data: function () {
            return {
                lampItemWidth: 0,
                lampIconHeight: 0,

//                lampIconSelectWidth: 0,
//                lampIconSelectHeight: 0,

                brandLogoHeight: 0,
                brandLogoWidth: 0,

                lampButtonBgHeight: 0,
                lampButtonIconWidth: 0,

                cardTitle: "心愿灯",
                lampText: '点亮',
                lampTextColor: '#ffffff',
                brandLogoImageOpacity: 1,

//                灯笼背景图片
                wishLampNomalIcon: "wish_lamp_normal_icon.png",
                wishLampSelectIcon: "wish_lamp_select_icon.png",
                wishLampDisableIcon: "wish_lamp_disable_icon.png",

                wishLampNomalBtn: "wish_lamp_normal_btn.png",
                wishLampSelectBtn: "wish_lamp_select_btn.png",
                wishLampDisableBtn: "wish_lamp_disable_btn.png",

                tipContent: '30天内努力为你备好，请持续关注',
                isShowSelect: false,
                lampPlaceHolderIcon: 'native://wish_lamp_normal_icon.png',
                wishLampBtnIcon: 'native://wish_lamp_normal_btn.png',
            }
        },
        props: {
            wishLampItem: {
                type: Object,
                default: {}
            },
        },
        watch: {
            wishLampItem: {
                handler: function (wishLampItem) {
                    console.log("watch=====wishLampItem");
                    this.updateLampState();
                },
                deep: true
            }
        },
        mounted: function () {
            console.log("mounted=====wishLampItem");

            this.updateLampState();
        },
        created: function () {
            this.lampItemWidth = Util.getLampItemWidth(this);
            this.lampIconHeight = Util.getLampItemIconHeight(this);

//            this.lampIconSelectWidth = Util.getLampSelectIconWidth(this);
//            this.lampIconSelectHeight = Util.getLampSelectIconHeight(this);

            this.brandLogoWidth = Util.getLampBrandLogoWidth(this);
            this.brandLogoHeight = Util.getLampBrandLogoHeight(this);

            this.lampButtonBgHeight = Util.getLampButtonBgHeight(this);
            this.lampButtonIconWidth = Util.getLampButtonBgIconHeight(this);
        },
        methods: {
            updateLampState: function () {
                if (this.wishLampItem.lampState === '2') {
                    this.lampText = "已点亮";
//                        this.lampTextColor = "#ffb5b7";
                    this.isShowSelect = true;
                    this.lampPlaceHolderIcon = 'native://wish_lamp_select_icon.png';
                    this.wishLampBtnIcon = 'native://wish_lamp_select_btn.png';
                } else if (this.wishLampItem.lampState === '3') {
//                        this.lampText = "已变灰";
                    this.lampTextColor = "#999999";
                    this.brandLogoImageOpacity = 0.5;
                    this.lampPlaceHolderIcon = 'native://wish_lamp_disable_icon.png';
                    this.wishLampBtnIcon = 'native://wish_lamp_disable_btn.png';
                } else {
                    this.lampPlaceHolderIcon = 'native://wish_lamp_normal_icon.png';
                    this.wishLampBtnIcon = 'native://wish_lamp_normal_btn.png';
                }
            },
            clickLampEvent: function () {
//                lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
//                如果lampState是2 || 3直接return掉 因为 点亮后不再允许再点亮
                if (this.wishLampItem.lampState === '2' || this.wishLampItem.lampState === '3') {
                    console.log('==已经不能再点击了')
//                    todo:show alert 不允许再点亮许愿灯文案提示  具体待向产品确认
//                    modal.alert({message: "已经点亮，不允许再点亮许愿灯", okTitle: "确认", cancelTitle: '取消'});
                    return;
                }
                console.log('=======clickLampEvent======');
//                this.lampText = "已点亮";
//                this.wishLampItem.lampState = '2'; //todo:同时通知其他变成3的状态

                var _this = this;
                var okString = "确认";
                modal.confirm({message: "每天仅有1次许愿机会哦，确认这个选择么？", okTitle: okString, cancelTitle: '取消'}, function (ret) {
//                        //

                    console.log("confirm====" + ret)
                    if (ret === okString) {
                        _this.$emit('changeLampState', _this.wishLampItem.brandId);
                    }
                });
            }
        }
    };
</script>