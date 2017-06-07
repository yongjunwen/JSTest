<!--心愿灯卡片-->
<template>

    <div class="slider-item-wish_lamp">
        <text class="text">{{wishLampObject.name}}</text>
        <!-- <image class="image" :src="wishLampObject.pic"></image> -->
    </div>
</template>

<style>
    .slider-item-wish_lamp {

        /*margin-top: 100px;*/
        /*margin-bottom: 100px;*/
        width: 600px;
        height: 946px;
        flex: auto;
        background-color: green;
    }

    .text {
        margin-top: 10px;
        margin-left: 10px;
        margin-right: 10px;
        font-size: 20px;
        height: 40px;
        color: #000000;
    }

    .image {
        margin-left: 10px;
        margin-right: -10px;
        width: 580px;
        height: 580px;
        resize: stretch;
    }
</style>

<script>
    export default {
        data: {},
        props: {
            wishLampObject: {
                type: Object,
                default: {}
            },
        }
    }
</script>