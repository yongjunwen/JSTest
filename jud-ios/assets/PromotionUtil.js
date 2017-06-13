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
     设计BrandItem宽高为600 * 910
     */
    getBrandItemWidth: function (_this) {
        var brandItemH = this.getBrandItemHeight(_this);
        var brandItemW = (600 / 910) * brandItemH;
        return brandItemW;
    },
    getBrandItemHeight: function (_this) {
        var sliderHeight = this.getSliderHeight(_this);
        var brandItemHeight = sliderHeight - 30; //30表示去看看按钮一半的高度
        return brandItemHeight;
    },

    /*
     设计BrandItem 头部图片背景 600 * 260
     */
    getBrandItemTopBgHeight: function (_this) {
        var itemWidth = this.getBrandItemWidth(_this);
        var topBgHeight = (260 / 600) * itemWidth;
        return topBgHeight;
    },

    /*
     设计BrandItem 头部图片背景上品牌logo  212 * 70
     */
    getBrandLogoWidth: function (_this) {
        var itemWidth = this.getBrandItemWidth(_this);
        var logoWidth = 212 * (itemWidth / 600);
        return logoWidth;
    },

    getBrandLogoHeight: function (_this) {
        var logoWidth = this.getBrandLogoWidth(_this);
        var logoH = (70 / 212) * logoWidth;
        return logoH;
    },
    /*
     设计BrandItem 底部背景图宽高 600 * 550
     */
    getBrandBottomImageHeight: function (_this) {
        var itemWidth = this.getBrandItemWidth(_this);
        var bottomImageH = (550 / 600) * itemWidth;
        return bottomImageH;
    },


    /*
     设计WishItem宽高为644 * 946
     */
    getWishItemWidth: function (_this) {
        var wishItemH = this.getWishItemHeight(_this);
        var wishItemW = (644 / 946) * wishItemH;
        return wishItemW;
    },
    getWishItemHeight: function (_this) {
        var sliderHeight = this.getSliderHeight(_this);
        var wishItemHeight = sliderHeight;
        return wishItemHeight;
    },
}
