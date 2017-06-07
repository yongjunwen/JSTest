<template>
    <!--<div class="bottomButtonBgDiv"-->
    <!--v-bind:style="{'backgroundColor':(this.index==selectIndex?buttonBgSelectColor:buttonBgColor)}">   -->
    <div class="bottomButtonBgDiv"
    >
        <text type='button' class="bottomButton"
              @click="buttonClick(index)">{{item.logoName}}
        </text>
    </div>
</template>

<style scoped>

    .bottomTextBgDiv {
        width: 120px;
        height: 60px;
        align-items: center;
        justify-content: center;
        background-color: red;
        border-radius: 20px;
    }

    .bottomText {
        background-color: white;
        /*  width: 60px;
        height: 40px;*/
        margin-left: 0;
        font-size: 16px;
        text-align: center;
    }

    .bottomText.check {
        background-color: red;
        border-color: #EE7A23;
    }

    .text {
        margin-top: 10px;
        margin-left: 10px;
        margin-right: 10px;
        font-size: 20px;
        height: 40px;
        color: #000000;
    }
</style>

<script>

    export default {
        data: {
            index: 0,
            selectIndex: 0,
            buttonBgSelectColor: "#ff329d",
            buttonBgColor: "#999999",
        },
        props: {
            item: {
                type: Object,
                default: {
                    logoName: null,
                    itemStyle: null,
                    name: null
                }
            },
        },
        methods: {
            buttonClick: function (index) {
                this.selectIndex = index;
                this.item.logoName = "wwww"
            }
        }
    }
</script>