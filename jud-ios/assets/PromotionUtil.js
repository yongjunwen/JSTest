/**
 * Created by wenyongjun on 2017/6/8.
 */

getWidth: function (width) {
    var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
    var deviceWidth = this.$getConfig().env.deviceWidth;

    var _width = width * deviceWidth / 750;
    return _width;
}

getHeight :function(height) {
    var platform = this.$getConfig().env.platform.toLowerCase();
//            获取设备高度
    var deviceHeight = this.$getConfig().env.deviceHeight;
    var deviceWidth = this.$getConfig().env.deviceWidth;

    var _height= height * deviceWidth / 750;
    return _height;
}