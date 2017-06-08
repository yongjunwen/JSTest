<!--单个心愿灯卡灯笼视图-->
<template>

    <div class="rootDiv">
        <div class="lampItem" @click="clickLampEvent()">

            <div class="lampIconBg" style="background-color: aquamarine">
                <image class="lampIcon" :src="wishLampIcon"></image>
                <div style="position: absolute;top: 0;justify-content: center;align-items: center;width: 132px;height: 144px">
                    <image class="brandLogo"
                           style="background-color: rosybrown;width: 96px;height: 60px;"></image>
                </div>
            </div>
            <div class="lampButtonBg">
                <image class="lampButtonIcon" :src="withLampButtonIcon"></image>
                <div style="position: absolute;top: 0;justify-content: center;align-items: center;width: 132px;height: 46px">
                    <text class="lanmpButtonText">点亮</text>
                </div>
            </div>
        </div>
    </div>
</template>

<style>


    .rootDiv {
        background-color: rosybrown;
    }

    .lampItem {
        background-color: darkred;
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
        /*margin-top: 60px;*/
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
    export default {
//        vue子视图引用的话data要写成如下方法样式
        data: function () {
            return {
                cardTitle: "心愿灯",
                wishLampIcon: "wish_lamp_icon.png",
                withLampButtonIcon: "wish_lamp_button.png",
                tipContent: '30天内努力为你备好，请持续关注'
            }
        },
        props: {
            wishLampObject: {
                type: Object,
                default: {}
            },
        },
        methods:{
            clickLampEvent:function () {
                console.log('=======clickLampEvent======');
            }
        }
    };
</script>