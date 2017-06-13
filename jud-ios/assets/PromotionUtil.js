/**
 * Created by wenyongjun on 2017/6/8.
 */

/*
 todo:获取对应宽度 待完善
 */

export default {

    getWidth: function (_this, width) {
        var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
        var deviceWidth = this.$getConfig().env.deviceWidth;

        var _width = width * deviceWidth / 750;
        return _width;
    },

    getHeight: function (_this) {
        var platform = _this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
        var deviceHeight = _this.$getConfig().env.deviceHeight;
        var deviceWidth = _this.$getConfig().env.deviceWidth;

        //            获取屏幕布局高度
        return 750 / deviceWidth * deviceHeight;
    },
    /*
     设计slider宽高为 750*940
     */
    getSliderHeight: function (_this) {
        var screenHeight = this.getHeight(_this);
        var sliderH = screenHeight - 400;//400表示减去上下 navi 、tab 、 间距高度
        return sliderH;
    },

    /*
     设计BrandIte宽高为600 * 910
     */
    getBrandItemWidth: function (_this) {
        var brandItemH = this.getBrandItemHeight(_this);
        var brandItemW = (600 / 910) * brandItemH;
        return brandItemW;
    },
    getBrandItemHeight: function (_this) {
        var sliderHeight = this.getSliderHeight(_this);
        var brandItemHeight = sliderHeight - 30;
        return brandItemHeight;
    },

}
