/**
 * Created by wenyongjun on 2017/6/8.
 */

/*
 todo:获取对应宽度 待完善
 */
function getWidth(width) {
    var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
    var deviceWidth = this.$getConfig().env.deviceWidth;

    var _width = width * deviceWidth / 750;
    return _width;
}

function getHeight(height) {
    var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
    var deviceHeight = this.$getConfig().env.deviceHeight;
    var deviceWidth = this.$getConfig().env.deviceWidth;

    //            获取屏幕布局高度
    return 750 / deviceWidth * deviceHeight;
}