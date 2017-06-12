<!--单个心愿灯卡灯笼视图-->
<template>
    <!--lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态-->
    <div class="rootDiv">
        <!---->
        <div class="lampItem" @click="clickLampEvent()">

            <div class="lampIconBg">
                <image class="lampIcon" :src="wishLampIcon"></image>
                <div style="position: absolute;top: 0;justify-content: center;align-items: center;width: 132px;height: 144px">
                    <image class="brandLogo"
                           style="background-color: rosybrown;width: 96px;height: 60px;"
                           :src="wishLampItem.brandIcon"></image>
                </div>
            </div>
            <div class="lampButtonBg">
                <image class="lampButtonIcon" :src="withLampButtonIcon"></image>
                <div style="position: absolute;top: 0;justify-content: center;align-items: center;width: 132px;height: 46px">
                    <text class="lanmpButtonText">{{lampText}}</text>
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
        width: 132px
    }

    .lampIconBg {
        width: 132px;
        height: 144px;
        justify-content: center;
        align-items: center;
    }

    .lampIcon {
        width: 132px;
        height: 144px;
    }

    .lampButtonBg {
        margin-top: 14px;
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
    export default {
//        vue子视图引用的话data要写成如下方法样式
        data: function () {
            return {
                cardTitle: "心愿灯",
                lampText: '点亮',
                wishLampIcon: "wish_lamp_icon.png",
                withLampButtonIcon: "wish_lamp_button.png",
                tipContent: '30天内努力为你备好，请持续关注'
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
                    if (this.wishLampItem.lampState === '2') {
                        this.lampText = "已点亮"
                    } else if (this.wishLampItem.lampState === '3') {
                        this.lampText = "已变灰"
                    }
                },
                deep: true
            }
        },
        mounted: function () {
            if (this.wishLampItem.lampState === '2') {
                this.lampText = "已点亮"
            } else if (this.wishLampItem.lampState === '3') {
                this.lampText = "已变灰"
            }

        },
        methods: {
            clickLampEvent: function () {
//                lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
//                如果lampState是2 || 3直接return掉 因为 点亮后不再允许再点亮
                if (this.wishLampItem.lampState === '2' || this.wishLampItem.lampState === '3') {
                    console.log('==已经不能再点击了')
//                    todo:show alert 不允许再点亮许愿灯文案提示  具体待向产品确认
                    modal.alert({message: "已经点亮，不允许再点亮许愿灯", okTitle: "确认", cancelTitle: '取消'});
                    return;
                }
                console.log('=======clickLampEvent======');
//                this.lampText = "已点亮";
//                this.wishLampItem.lampState = '2'; //todo:同时通知其他变成3的状态

                this.$emit('changeLampState', this.wishLampItem.brandId);
            }
        }
    };
</script>