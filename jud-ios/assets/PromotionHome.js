// { "framework": "Vue" }
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(1)
	)

	/* script */
	__vue_exports__ = __webpack_require__(2)

	/* template */
	var __vue_template__ = __webpack_require__(20)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PromotionHome.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-3b147f4e"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__
	module.exports.el = 'true'
	new Vue(module.exports)


/***/ }),
/* 1 */
/***/ (function(module, exports) {

	module.exports = {
	  "bgView": {
	    "width": 750
	  },
	  "bgImage": {
	    "width": 750
	  },
	  "contentView": {
	    "position": "absolute",
	    "width": 750
	  },
	  "slider-neighbor": {
	    "top": 0,
	    "alignItems": "center"
	  },
	  "bottomTab": {
	    "marginTop": 40,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "bottomTabContentBg": {
	    "backgroundColor": "rgba(0,0,0,0.7)",
	    "flexDirection": "row",
	    "paddingLeft": 15,
	    "paddingRight": 15,
	    "borderRadius": 40,
	    "overflow": "hidden"
	  },
	  "bottomTextBgDiv": {
	    "alignItems": "center",
	    "justifyContent": "center"
	  },
	  "bottomText": {
	    "fontSize": 22,
	    "color": "#FFFFFF"
	  }
	}

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionBottom = __webpack_require__(3);

	var _PromotionBottom2 = _interopRequireDefault(_PromotionBottom);

	var _PromotionProductView = __webpack_require__(7);

	var _PromotionProductView2 = _interopRequireDefault(_PromotionProductView);

	var _PromotionWishLampView = __webpack_require__(12);

	var _PromotionWishLampView2 = _interopRequireDefault(_PromotionWishLampView);

	var _PromotionUtil = __webpack_require__(10);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	var modal = jud.requireModule('modal');
	exports.default = {
	    components: {
	        PromotionProductView: _PromotionProductView2.default,
	        PromotionWishLampView: _PromotionWishLampView2.default,
	        PromotionBottom: _PromotionBottom2.default
	    },
	    data: {
	        test: 'test222',
	        contentTop: 0,
	        selectIndex: 0,
	        neighborSpace: 0,
	        buttonBgSelectColor: "#000000",
	        deviceHeight: 10,
	        sliderHeight: 0,

	        bottomTabHeight: 0,
	        bottomTextWidth: 0,

	        bottomTabImageHeight: 0,
	        bottomTabImageWidth: 0,
	        buttonBgColor: null,
	        //            bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
	        bgImage: 'slider_bg_image.png',
	        productList: [
	        //                {
	        //                    itemStyle: "1",
	        //                    tabName: "魅族",
	        //                    tabImage: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
	        //                    name: "您许的愿望已为您备好，魅族",
	        //                    brandLogo: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
	        //                    topPic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
	        //                    pic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg"
	        //                },
	        {
	            itemStyle: "1",
	            tabName: "华为",
	            tabImage: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1496912449&di=1d908831b09e08208c79e53dce78fc73&src=http://pic.qiantucdn.com/58pic/12/38/18/13758PIC4GV.jpg",
	            name: "您许的愿望已为您备好，华为",
	            brandLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
	            topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            tabName: "小米",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497517343&di=baff522d5450339011176b5c1fea1302&imgtype=jpg&er=1&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_0_96973789D2128229081_23.jpg",
	            name: "您许的愿望已为您备好，小米",
	            brandLogo: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1052774542,692148190&fm=26&gp=0.jpg",
	            topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            tabName: "魅族",
	            tabImage: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg",
	            name: "您许的愿望已为您备好，魅族",
	            brandLogo: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg",
	            topPic: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1497236240&di=8ea6a518f36ef15963f7605141042cb3&src=http://cdn.waaaat.welovead.com/upload/rss_download/20151022/600_0/201510221902419993.jpg",
	            pic: "https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/bbaf504ee7a59061636863a02b0a54c0_222_222.jpg"
	        }, {
	            itemStyle: "1",
	            tabName: "格力",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922663211&di=fd30c4a8b7b1ba325925c91cb2a32586&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F57%2F08%2F92G58PICHbX.jpg",
	            name: "您许的愿望已为您备好，格力",
	            brandLogo: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=572491635,2679502336&fm=26&gp=0.jpg",
	            topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/pic/2013-01-22/927_p56.jpg ",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
	        }, {
	            tabName: "心愿灯",
	            itemStyle: "2",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg",
	            name: "要降价!京东和阿里打价格战:刘强东发飙",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t1870/20/2688983380/490055/66145088/5715bc6aN4933b67c.jpg!q70.jpg",
	            brandList: [{
	                lampState: '1',
	                brandId: '111',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
	            }, {
	                lampState: '1',
	                brandId: '112',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497517343&di=baff522d5450339011176b5c1fea1302&imgtype=jpg&er=1&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_0_96973789D2128229081_23.jpg'
	            }, {
	                lampState: '1',
	                brandId: '113',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922663211&di=fd30c4a8b7b1ba325925c91cb2a32586&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F57%2F08%2F92G58PICHbX.jpg'
	            }, {
	                lampState: '1',
	                brandId: '114',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
	            }, {
	                lampState: '1',
	                brandId: '115',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
	            }, {
	                lampState: '1',
	                brandId: '116',
	                brandIcon: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg'
	            }]
	        }]
	    },
	    methods: {

	        buttonClick: function buttonClick(index) {
	            this.selectIndex = index;
	        },

	        changeEvent: function changeEvent(e) {
	            var selectIndexStr = e["index"];

	            //                modal.toast({
	            //                    message: selectIndexStr,
	            //                    duration: 1.8
	            //                })

	            this.selectIndex = Number(selectIndexStr);
	            // if(this.selectIndex  == 0){
	            //   this.selectIndex  = 1;
	            // }else{
	            //   this.selectIndex  = 0;
	            // }
	            console.log(e);
	            //                和原生端进行通信协议
	            var nativeEventHandle = __jud_require_module__('nativeEventHandle');

	            var self = this;
	            //                nativeEventHandle.handleEvent(
	            //                    "kScrollChangeKey", //通信key
	            //                    {"index": e},
	            //                    function (ret) {
	            //                        // ret就是我们传入的{"Hello": "World"}
	            //                    });
	        }
	    },
	    created: function created() {
	        //
	        var platform = this.$getConfig().env.platform.toLowerCase();
	        //            获取设备高度
	        var deviceHeight = this.$getConfig().env.deviceHeight;
	        var deviceWidth = this.$getConfig().env.deviceWidth;

	        console.log("*==deviceHeight=" + deviceHeight + "==deviceWidth=" + deviceWidth);

	        //            获取屏幕布局高度
	        var height = _PromotionUtil2.default.getHeight(this); //750 / deviceWidth * deviceHeight;
	        //            var testheight = Util.getHeight(this);
	        console.log('deviceHeight=' + deviceHeight, 'viewH=' + height);

	        var sliderH = _PromotionUtil2.default.getSliderHeight(this);

	        this.sliderHeight = sliderH;

	        //            设备类型匹配
	        if (platform === "ios") {
	            //                height -= 5;
	            this.contentTop = 180;
	            console.log("=匹配到=iOS");
	        } else if (platform === "android") {
	            height -= 5;
	            console.log("=匹配到=Android");
	            this.contentTop = 180;
	        } else {
	            console.log("=没有匹配到=");
	        }
	        this.deviceHeight = height;

	        console.log("*==处理后" + this.deviceHeight + "height=" + height + "platform=" + platform);

	        this.bottomTabHeight = _PromotionUtil2.default.scale(this) * 90;
	        this.bottomTextWidth = _PromotionUtil2.default.scale(this) * 130;
	        this.bottomTabImageHeight = _PromotionUtil2.default.scale(this) * 70;
	        this.bottomTabImageWidth = _PromotionUtil2.default.scale(this) * 100;

	        var _nSpace = 55;
	        if (platform === "android") {
	            _nSpace = 30;
	        }
	        this.neighborSpace = _PromotionUtil2.default.scale(this) * _nSpace;
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(4)
	)

	/* script */
	__vue_exports__ = __webpack_require__(5)

	/* template */
	var __vue_template__ = __webpack_require__(6)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PromotionBottom.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-7d7f61b6"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__


/***/ }),
/* 4 */
/***/ (function(module, exports) {

	module.exports = {
	  "bottomTextBgDiv": {
	    "width": 120,
	    "height": 60,
	    "alignItems": "center",
	    "justifyContent": "center",
	    "backgroundColor": "#FF0000",
	    "borderRadius": 20
	  },
	  "bottomText": {
	    "backgroundColor": "#FFFFFF",
	    "marginLeft": 0,
	    "fontSize": 16,
	    "textAlign": "center"
	  },
	  "text": {
	    "marginTop": 10,
	    "marginLeft": 10,
	    "marginRight": 10,
	    "fontSize": 20,
	    "height": 40,
	    "color": "#000000"
	  }
	}

/***/ }),
/* 5 */
/***/ (function(module, exports) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//


	exports.default = {
	    data: {
	        index: 0,
	        selectIndex: 0,
	        buttonBgSelectColor: "#ff329d",
	        buttonBgColor: "#999999"
	    },
	    props: {
	        item: {
	            type: Object,
	            default: {
	                logoName: null,
	                itemStyle: null,
	                name: null
	            }
	        }
	    },
	    methods: {
	        buttonClick: function buttonClick(index) {
	            this.selectIndex = index;
	            this.item.logoName = "wwww";
	        }
	    }
	};
	module.exports = exports["default"];

/***/ }),
/* 6 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["bottomButtonBgDiv"]
	  }, [_c('text', {
	    staticClass: ["bottomButton"],
	    attrs: {
	      "type": "button"
	    },
	    on: {
	      "click": function($event) {
	        _vm.buttonClick(_vm.index)
	      }
	    }
	  }, [_vm._v(_vm._s(_vm.item.logoName) + "\n    ")])])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(8)
	)

	/* script */
	__vue_exports__ = __webpack_require__(9)

	/* template */
	var __vue_template__ = __webpack_require__(11)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PromotionProductView.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-e4d91bac"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__


/***/ }),
/* 8 */
/***/ (function(module, exports) {

	module.exports = {
	  "rootDiv": {
	    "width": 600,
	    "height": 940
	  },
	  "slider-item": {
	    "width": 600,
	    "height": 910,
	    "backgroundColor": "#FFFFFF",
	    "borderRadius": 10,
	    "overflow": "hidden"
	  },
	  "topItemBg": {
	    "width": 600,
	    "height": 260
	  },
	  "topItemBgImage": {
	    "width": 600,
	    "height": 260
	  },
	  "bottom-image": {
	    "marginLeft": 0,
	    "marginRight": 0,
	    "width": 600,
	    "height": 550
	  },
	  "topItemContent": {
	    "top": 0,
	    "width": 600,
	    "alignItems": "center",
	    "justifyContent": "center",
	    "position": "absolute"
	  },
	  "seperateicon": {
	    "marginTop": 20,
	    "height": 8,
	    "width": 60
	  },
	  "curveImageBg": {
	    "bottom": 0,
	    "alignItems": "center",
	    "justifyContent": "center",
	    "position": "absolute"
	  },
	  "lineItem": {
	    "marginTop": 18,
	    "fontSize": 26,
	    "color": "#FFFFFF"
	  },
	  "topItemContentText": {
	    "marginTop": 18,
	    "fontSize": 26,
	    "color": "#FFFFFF"
	  },
	  "bottomDiv": {
	    "bottom": 0,
	    "width": 600,
	    "alignItems": "center",
	    "justifyContent": "center",
	    "position": "absolute"
	  },
	  "wishText": {
	    "fontSize": 25,
	    "color": "#333333"
	  },
	  "seeDiv": {
	    "marginTop": 10,
	    "height": 76,
	    "width": 216,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "seeText": {
	    "color": "#FFFFFF",
	    "fontSize": 22
	  }
	}

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionUtil = __webpack_require__(10);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	exports.default = {
	    data: function data() {
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
	            topContentText: '[加入我们，创建未来]'
	        };
	    },
	    props: {
	        itemProduct: {
	            type: Object,
	            default: {}
	        }
	    },
	    methods: {
	        toSeeClick: function toSeeClick() {
	            console.log('--------toSeeClick----+++');
	        }
	    },
	    created: function created() {
	        this.brandRootHeight = _PromotionUtil2.default.getSliderHeight(this);
	        this.brandItemHeight = _PromotionUtil2.default.getBrandItemHeight(this);
	        this.brandItemWidth = _PromotionUtil2.default.getBrandItemWidth(this);
	        this.topItemBgHeight = _PromotionUtil2.default.getBrandItemTopBgHeight(this);

	        this.brandItemCurveHeight = _PromotionUtil2.default.getBrandItemCurveHeigh(this);

	        this.brandLogoHeight = _PromotionUtil2.default.getBrandLogoHeight(this);
	        this.brandLogoWidth = _PromotionUtil2.default.getBrandLogoWidth(this);

	        this.brandItemBottomImageHeight = _PromotionUtil2.default.getBrandBottomImageHeight(this);
	    }
	}; //
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	module.exports = exports['default'];

/***/ }),
/* 10 */
/***/ (function(module, exports) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});
	/**
	 * Created by wenyongjun on 2017/6/8.
	 */

	/*
	 todo:获取对应宽度 待完善
	 */

	exports.default = {

	    //     getWidth: function (_this, width) {
	    //         var platform = this.$getConfig().env.platform.toLowerCase();
	    // //            获取设备高度
	    //         var deviceWidth = this.$getConfig().env.deviceWidth;
	    //
	    //         var _width = width * deviceWidth / 750;
	    //         return _width;
	    //     },

	    getHeight: function getHeight(_this) {
	        var platform = _this.$getConfig().env.platform.toLowerCase();
	        //            获取设备高度
	        var deviceHeight = _this.$getConfig().env.deviceHeight;
	        var deviceWidth = _this.$getConfig().env.deviceWidth;

	        //            获取屏幕布局高度
	        return 750 / deviceWidth * (deviceHeight - 40); //40为减去状态栏的高度 默认使用40
	    },
	    /*
	     设计slider宽高为 750*940
	     */
	    getSliderHeight: function getSliderHeight(_this) {
	        var screenHeight = this.getHeight(_this);
	        var sliderH = screenHeight - 400; //400表示减去上下 navi 、tab 、 间距高度
	        return sliderH;
	    },

	    /*
	     设计BrandItem宽高为600 * 910
	     */
	    getBrandItemWidth: function getBrandItemWidth(_this) {
	        // var brandItemH = this.getBrandItemHeight(_this);
	        // var brandItemW = (600 / 910) * brandItemH;
	        return 606 * this.scale(_this);
	    },
	    //弧度高度
	    getBrandItemCurveHeigh: function getBrandItemCurveHeigh(_this) {

	        return 20 * this.scale(_this);
	    },
	    getBrandItemHeight: function getBrandItemHeight(_this) {
	        var sliderHeight = this.getSliderHeight(_this);
	        var brandItemHeight = sliderHeight - 30; //30表示去看看按钮一半的高度
	        return brandItemHeight;
	    },

	    /*
	     设计BrandItem 头部图片背景 600 * 266
	     */
	    getBrandItemTopBgHeight: function getBrandItemTopBgHeight(_this) {
	        return 266 * this.scale(_this);
	    },

	    /*
	     设计BrandItem 头部图片背景上品牌logo  212 * 70
	     */
	    getBrandLogoWidth: function getBrandLogoWidth(_this) {
	        var itemWidth = this.getBrandItemWidth(_this);
	        var logoWidth = 212 * (itemWidth / 600);
	        return logoWidth;
	    },

	    getBrandLogoHeight: function getBrandLogoHeight(_this) {
	        var logoWidth = this.getBrandLogoWidth(_this);
	        var logoH = 70 / 212 * logoWidth;
	        return logoH;
	    },
	    /*
	     设计BrandItem 底部背景图宽高 600 * 550
	     */
	    getBrandBottomImageHeight: function getBrandBottomImageHeight(_this) {
	        var itemWidth = this.getBrandItemWidth(_this);
	        var bottomImageH = 550 / 600 * itemWidth;
	        return bottomImageH;
	    },

	    /*
	     设计WishItem宽高为644 * 946
	     */
	    getWishItemWidth: function getWishItemWidth(_this) {
	        var wishItemH = this.getWishItemHeight(_this);
	        var wishItemW = 644 / 946 * wishItemH;
	        return wishItemW;
	    },
	    getWishItemHeight: function getWishItemHeight(_this) {
	        var sliderHeight = this.getSliderHeight(_this);
	        var wishItemHeight = sliderHeight;
	        return wishItemHeight;
	    },

	    /*
	     宽、高度适配比例
	     */
	    scale: function scale(_this) {
	        // var deviceWidth = _this.$getConfig().env.deviceWidth;
	        //
	        // var _scale = deviceWidth / 750;

	        var brandItemH = this.getBrandItemHeight(_this);
	        var _scale = brandItemH / 910;
	        return _scale;
	    },

	    /*
	     =====================
	     心愿灯元素相关frame
	     =====================
	     */
	    //宽为132
	    getLampItemWidth: function getLampItemWidth(_this) {
	        // var wishItemW = this.getWishItemWidth(_this);
	        // var lampItemW = (132 / 644) * wishItemW;
	        // return lampItemW;
	        return 206 * this.scale(_this);
	    },
	    //132 * 144
	    getLampItemIconHeight: function getLampItemIconHeight(_this) {
	        // var lampW = this.getLampItemWidth(_this);
	        // var lampIconH = ( 144 / 132) * lampW;
	        // return lampIconH;
	        return 190 * this.scale(_this);
	    },

	    //206 * 190
	    getLampSelectIconWidth: function getLampSelectIconWidth(_this) {

	        return 206 * this.scale(_this);
	    },
	    getLampSelectIconHeight: function getLampSelectIconHeight(_this) {

	        return 190 * this.scale(_this);
	    },
	    /*
	     品牌logo为96 * 60
	     */
	    getLampBrandLogoWidth: function getLampBrandLogoWidth(_this) {
	        return 96 * this.scale(_this);
	    },
	    getLampBrandLogoHeight: function getLampBrandLogoHeight(_this) {
	        return 60 * this.scale(_this);
	    },

	    getLampButtonBgHeight: function getLampButtonBgHeight(_this) {
	        return 46 * this.scale(_this);
	    },
	    getLampButtonBgIconHeight: function getLampButtonBgIconHeight(_this) {
	        return 126 * this.scale(_this);
	    }
	};
	module.exports = exports["default"];

/***/ }),
/* 11 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rootDiv"],
	    style: {
	      height: _vm.brandRootHeight,
	      width: _vm.brandItemWidth
	    }
	  }, [_c('div', {
	    staticClass: ["slider-item"],
	    style: {
	      height: _vm.brandItemHeight,
	      width: _vm.brandItemWidth
	    },
	    on: {
	      "click": function($event) {
	        _vm.toSeeClick()
	      }
	    }
	  }, [_c('div', {
	    staticClass: ["topItemBg"],
	    style: {
	      height: _vm.topItemBgHeight,
	      width: _vm.brandItemWidth
	    }
	  }, [_c('image', {
	    staticClass: ["topItemBgImage"],
	    style: {
	      height: _vm.topItemBgHeight,
	      width: _vm.brandItemWidth
	    },
	    attrs: {
	      "src": _vm.itemProduct.topPic
	    }
	  }), _c('div', {
	    staticClass: ["topItemContent"],
	    style: {
	      width: _vm.brandItemWidth
	    }
	  }, [_c('image', {
	    staticStyle: {
	      width: "212px",
	      height: "70px",
	      backgroundColor: "aquamarine",
	      marginTop: "18px"
	    },
	    style: {
	      height: _vm.brandLogoHeight,
	      width: _vm.brandLogoWidth
	    },
	    attrs: {
	      "src": _vm.itemProduct.brandLogo
	    }
	  }), _c('image', {
	    staticClass: ["seperateicon"],
	    attrs: {
	      "src": _vm.seperateicon
	    }
	  }), _c('text', {
	    staticClass: ["topItemContentText"]
	  }, [_vm._v(_vm._s(_vm.topContentText))])]), _c('div', {
	    staticClass: ["curveImageBg"],
	    style: {
	      height: _vm.brandItemCurveHeight,
	      width: _vm.brandItemWidth
	    }
	  }, [_c('image', {
	    staticClass: ["curveImage"],
	    style: {
	      height: _vm.brandItemCurveHeight,
	      width: _vm.brandItemWidth
	    },
	    attrs: {
	      "src": _vm.curveImage
	    }
	  })])]), _c('image', {
	    staticClass: ["bottom-image"],
	    style: {
	      height: _vm.brandItemBottomImageHeight,
	      width: _vm.brandItemWidth
	    },
	    attrs: {
	      "src": _vm.itemProduct.pic
	    }
	  })]), _c('div', {
	    staticClass: ["bottomDiv"],
	    staticStyle: {
	      justifyContent: "center",
	      alignItems: "center"
	    },
	    style: {
	      width: _vm.brandItemWidth
	    }
	  }, [_c('text', {
	    staticClass: ["wishText"]
	  }, [_vm._v(_vm._s(_vm.itemProduct.name))]), _c('div', {
	    staticClass: ["seeDiv"],
	    on: {
	      "click": function($event) {
	        _vm.toSeeClick()
	      }
	    }
	  }, [_c('image', {
	    staticStyle: {
	      width: "216px",
	      height: "76px"
	    },
	    attrs: {
	      "src": _vm.seeButtonImage
	    }
	  })])])])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(13)
	)

	/* script */
	__vue_exports__ = __webpack_require__(14)

	/* template */
	var __vue_template__ = __webpack_require__(19)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PromotionWishLampView.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-6768115e"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__


/***/ }),
/* 13 */
/***/ (function(module, exports) {

	module.exports = {
	  "rooDiv": {
	    "width": 610,
	    "height": 950,
	    "borderRadius": 10,
	    "overflow": "hidden"
	  },
	  "bgImage": {
	    "width": 610,
	    "height": 950
	  },
	  "topItemContent": {
	    "width": 600
	  },
	  "topItemContentText": {
	    "marginTop": 45,
	    "fontSize": 40,
	    "color": "#ffffff"
	  },
	  "lineItem": {
	    "marginTop": 22,
	    "fontSize": 26,
	    "color": "#FFFFFF"
	  },
	  "seperateicon": {
	    "marginTop": 22,
	    "height": 8,
	    "width": 60
	  },
	  "tipContent": {
	    "marginTop": 34,
	    "color": "#ffffff",
	    "fontSize": 26
	  },
	  "contentDiv": {
	    "position": "absolute",
	    "top": 0
	  },
	  "bottomTipContent": {
	    "marginTop": 40,
	    "color": "#FFFFFF",
	    "fontSize": 22
	  }
	}

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionWishLampItemView = __webpack_require__(15);

	var _PromotionWishLampItemView2 = _interopRequireDefault(_PromotionWishLampItemView);

	var _PromotionUtil = __webpack_require__(10);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	exports.default = {
	    components: {
	        PromotionWishLampItemView: _PromotionWishLampItemView2.default
	    },
	    //        vue子视图引用的话data要写成如下方法样式
	    data: function data() {
	        return {
	            wishRootHeight: 0,
	            wishRootWidth: 0,

	            titleFontSize: 0,
	            titleTop: 0,

	            contentFontSize: 0,
	            contentTop: 0,

	            marginTop1: 0,
	            marginTop2: 0,
	            marginTop3: 0,

	            cardTitle: "心愿灯",
	            seperateicon: 'zs_d_icon_05.png',
	            wishLampBg: "wish_lamp_bg_image.png",
	            tipContent: '30天内努力为你备好，请持续关注',
	            bottomTipContent: '每天仅有有1次许愿机会'
	        };
	    },
	    props: {
	        wishLampObject: {
	            type: Object,
	            default: {}
	        }
	    },
	    methods: {
	        itemClick: function itemClick(index) {
	            console.log('itemClick=====');
	        },
	        changeLampStateEvent: function changeLampStateEvent(lampItem) {
	            console.log('changeLampStateEvent=====' + lampItem + '获取到');
	            console.log('array=' + this.wishLampObject.brandList);

	            this.wishLampObject.brandList.forEach(function (item, index) {
	                console.log('brandId=' + item['brandId']);
	                if (item['brandId'] === lampItem) {
	                    item['lampState'] = '2';
	                    console.log('changeLampStateEvent====lampState=2');
	                } else {
	                    console.log('changeLampStateEvent====lampState=3');
	                    item['lampState'] = '3';
	                }
	            });
	            //                for (var item in this.wishLampObject.brandList) {
	            //
	            //                }
	        }
	    },
	    created: function created() {
	        this.wishRootHeight = _PromotionUtil2.default.getWishItemHeight(this);
	        this.wishRootWidth = _PromotionUtil2.default.getWishItemWidth(this);

	        this.titleFontSize = 40 * _PromotionUtil2.default.scale(this);
	        this.titleTop = 65 * _PromotionUtil2.default.scale(this);

	        this.contentFontSize = 26 * _PromotionUtil2.default.scale(this);
	        this.contentTop = 34 * _PromotionUtil2.default.scale(this);

	        this.marginTop1 = 50 * _PromotionUtil2.default.scale(this);
	        this.marginTop2 = 100 * _PromotionUtil2.default.scale(this);
	        this.marginTop3 = 10 * _PromotionUtil2.default.scale(this);
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(16)
	)

	/* script */
	__vue_exports__ = __webpack_require__(17)

	/* template */
	var __vue_template__ = __webpack_require__(18)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PromotionWishLampItemView.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-108af511"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__


/***/ }),
/* 16 */
/***/ (function(module, exports) {

	module.exports = {
	  "lampIconBg": {
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "brandLogo": {
	    "backgroundColor": "#BC8F8F",
	    "width": 96,
	    "height": 60
	  },
	  "lampButtonBg": {
	    "width": 132,
	    "height": 46,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "lampButtonIcon": {
	    "width": 126,
	    "height": 46
	  },
	  "lanmpButtonText": {
	    "color": "#FFFFFF",
	    "fontSize": 20
	  }
	}

/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionUtil = __webpack_require__(10);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	var modal = jud.requireModule('modal');
	exports.default = {
	    //        vue子视图引用的话data要写成如下方法样式
	    data: function data() {
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

	            tipContent: '30天内努力为你备好，请持续关注'
	        };
	    },
	    props: {
	        wishLampItem: {
	            type: Object,
	            default: {}
	        }
	    },
	    watch: {
	        wishLampItem: {
	            handler: function handler(wishLampItem) {
	                console.log("watch=====wishLampItem");
	                if (this.wishLampItem.lampState === '2') {
	                    this.lampText = "已点亮";
	                    //                        this.lampTextColor = "#ffb5b7";
	                } else if (this.wishLampItem.lampState === '3') {
	                    //                        this.lampText = "已变灰";
	                    this.lampTextColor = "#999999";
	                    this.brandLogoImageOpacity = 0.5;
	                }
	            },
	            deep: true
	        }
	    },
	    mounted: function mounted() {
	        if (this.wishLampItem.lampState === '2') {
	            this.lampText = "已点亮";
	        } else if (this.wishLampItem.lampState === '3') {
	            this.lampText = "已变灰";
	        }
	    },
	    created: function created() {
	        this.lampItemWidth = _PromotionUtil2.default.getLampItemWidth(this);
	        this.lampIconHeight = _PromotionUtil2.default.getLampItemIconHeight(this);

	        //            this.lampIconSelectWidth = Util.getLampSelectIconWidth(this);
	        //            this.lampIconSelectHeight = Util.getLampSelectIconHeight(this);

	        this.brandLogoWidth = _PromotionUtil2.default.getLampBrandLogoWidth(this);
	        this.brandLogoHeight = _PromotionUtil2.default.getLampBrandLogoHeight(this);

	        this.lampButtonBgHeight = _PromotionUtil2.default.getLampButtonBgHeight(this);
	        this.lampButtonIconWidth = _PromotionUtil2.default.getLampButtonBgIconHeight(this);
	    },
	    methods: {
	        clickLampEvent: function clickLampEvent() {
	            //                lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
	            //                如果lampState是2 || 3直接return掉 因为 点亮后不再允许再点亮
	            if (this.wishLampItem.lampState === '2' || this.wishLampItem.lampState === '3') {
	                console.log('==已经不能再点击了');
	                //                    todo:show alert 不允许再点亮许愿灯文案提示  具体待向产品确认
	                //                    modal.alert({message: "已经点亮，不允许再点亮许愿灯", okTitle: "确认", cancelTitle: '取消'});
	                return;
	            }
	            console.log('=======clickLampEvent======');
	            //                this.lampText = "已点亮";
	            //                this.wishLampItem.lampState = '2'; //todo:同时通知其他变成3的状态

	            var _this = this;
	            var okString = "确认";
	            modal.confirm({ message: "每天仅有1次许愿机会哦，确认这个选择么？", okTitle: okString, cancelTitle: '取消' }, function (ret) {
	                //                        //

	                console.log("confirm====" + ret);
	                if (ret === okString) {
	                    _this.$emit('changeLampState', _this.wishLampItem.brandId);
	                }
	            });
	        }
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 18 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rootDiv"]
	  }, [_c('div', {
	    staticClass: ["lampItem"],
	    style: {
	      width: _vm.lampItemWidth
	    },
	    on: {
	      "click": function($event) {
	        _vm.clickLampEvent()
	      }
	    }
	  }, [_c('div', {
	    staticClass: ["lampIconBg"],
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    }
	  }, [(_vm.wishLampItem.lampState == 1) ? _c('image', {
	    staticClass: ["lampIcon"],
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    },
	    attrs: {
	      "src": _vm.wishLampNomalIcon
	    }
	  }) : _vm._e(), (_vm.wishLampItem.lampState == 2) ? _c('image', {
	    staticClass: ["lampSelectIcon"],
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    },
	    attrs: {
	      "src": _vm.wishLampSelectIcon
	    }
	  }) : _vm._e(), (_vm.wishLampItem.lampState == 3) ? _c('image', {
	    staticClass: ["lampIcon"],
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    },
	    attrs: {
	      "src": _vm.wishLampDisableIcon
	    }
	  }) : _vm._e(), _c('div', {
	    staticStyle: {
	      position: "absolute",
	      top: "0",
	      justifyContent: "center",
	      alignItems: "center"
	    },
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    }
	  }, [_c('image', {
	    staticClass: ["brandLogo"],
	    style: {
	      opacity: _vm.brandLogoImageOpacity,
	      height: _vm.brandLogoHeight,
	      width: _vm.brandLogoWidth
	    },
	    attrs: {
	      "src": _vm.wishLampItem.brandIcon
	    }
	  })])]), _c('div', {
	    staticClass: ["lampButtonBg"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampItemWidth
	    }
	  }, [(_vm.wishLampItem.lampState == 1) ? _c('image', {
	    staticClass: ["lampButtonIcon"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampButtonIconWidth
	    },
	    attrs: {
	      "src": _vm.wishLampNomalBtn
	    }
	  }) : _vm._e(), (_vm.wishLampItem.lampState == 2) ? _c('image', {
	    staticClass: ["lampButtonIcon"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampButtonIconWidth
	    },
	    attrs: {
	      "src": _vm.wishLampSelectBtn
	    }
	  }) : _vm._e(), (_vm.wishLampItem.lampState == 3) ? _c('image', {
	    staticClass: ["lampButtonIcon"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampButtonIconWidth
	    },
	    attrs: {
	      "src": _vm.wishLampDisableBtn
	    }
	  }) : _vm._e(), _c('div', {
	    staticStyle: {
	      position: "absolute",
	      top: "0",
	      justifyContent: "center",
	      alignItems: "center",
	      width: "132px",
	      height: "46px"
	    },
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampItemWidth
	    }
	  }, [_c('text', {
	    staticClass: ["lanmpButtonText"],
	    style: {
	      color: _vm.lampTextColor
	    }
	  }, [_vm._v(_vm._s(_vm.lampText))])])])])])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }),
/* 19 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rooDiv"],
	    style: {
	      height: _vm.wishRootHeight,
	      width: _vm.wishRootWidth
	    }
	  }, [_c('div', {
	    staticClass: ["bgImageDiv"]
	  }, [_c('image', {
	    staticClass: ["bgImage"],
	    style: {
	      height: _vm.wishRootHeight,
	      width: _vm.wishRootWidth
	    },
	    attrs: {
	      "src": _vm.wishLampBg
	    }
	  })]), _c('div', {
	    staticClass: ["contentDiv"]
	  }, [_c('div', {
	    staticClass: ["topItemContent"],
	    style: {
	      width: _vm.wishRootWidth
	    }
	  }, [_c('div', {
	    staticStyle: {
	      alignItems: "center",
	      justifyContent: "center"
	    }
	  }, [_c('text', {
	    staticClass: ["topItemContentText"],
	    style: {
	      fontSize: _vm.titleFontSize,
	      marginTop: _vm.titleTop
	    }
	  }, [_vm._v(_vm._s(_vm.cardTitle))]), _c('image', {
	    staticClass: ["seperateicon"],
	    attrs: {
	      "src": _vm.seperateicon
	    }
	  }), _c('text', {
	    staticClass: ["tipContent"],
	    style: {
	      fontSize: _vm.contentFontSize,
	      marginTop: _vm.contentTop
	    }
	  }, [_vm._v(_vm._s(_vm.tipContent))])])]), _c('div', {
	    staticStyle: {
	      flexDirection: "row"
	    }
	  }, [_c('div', {
	    staticStyle: {
	      marginLeft: "25px"
	    },
	    style: {
	      marginTop: _vm.marginTop1
	    }
	  }, [(_vm.wishLampObject.brandList[0]) ? _c('promotion-wish-lamp-item-view', {
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[0]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e(), (_vm.wishLampObject.brandList[3]) ? _c('promotion-wish-lamp-item-view', {
	    staticStyle: {
	      marginTop: "26px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[3]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e()], 1), _c('div', {
	    staticStyle: {
	      marginTop: "120px",
	      marginLeft: "-20px"
	    },
	    style: {
	      marginTop: _vm.marginTop2
	    }
	  }, [(_vm.wishLampObject.brandList[1]) ? _c('promotion-wish-lamp-item-view', {
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[1]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e(), (_vm.wishLampObject.brandList[4]) ? _c('promotion-wish-lamp-item-view', {
	    staticStyle: {
	      marginTop: "26px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[4]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e()], 1), _c('div', {
	    staticStyle: {
	      marginTop: "30px",
	      marginLeft: "-20px"
	    },
	    style: {
	      marginTop: _vm.marginTop3
	    }
	  }, [(_vm.wishLampObject.brandList[2]) ? _c('promotion-wish-lamp-item-view', {
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[2]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e(), (_vm.wishLampObject.brandList[5]) ? _c('promotion-wish-lamp-item-view', {
	    staticStyle: {
	      marginTop: "26px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[5]
	    },
	    on: {
	      "changeLampState": _vm.changeLampStateEvent
	    }
	  }) : _vm._e()], 1)]), _c('div', {
	    staticClass: ["bottom"],
	    staticStyle: {
	      width: "610px"
	    },
	    style: {
	      width: _vm.wishRootWidth
	    }
	  }, [_c('div', {
	    staticStyle: {
	      alignItems: "center",
	      justifyContent: "center"
	    }
	  }, [_c('text', {
	    staticClass: ["bottomTipContent"]
	  }, [_vm._v(_vm._s(_vm.bottomTipContent))])])])])])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }),
/* 20 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rootDiv"]
	  }, [_c('div', {
	    staticClass: ["bgView"],
	    style: {
	      height: _vm.deviceHeight
	    }
	  }, [_c('image', {
	    staticClass: ["bgImage"],
	    style: {
	      height: _vm.deviceHeight
	    },
	    attrs: {
	      "src": _vm.bgImage
	    }
	  })]), _c('div', {
	    staticClass: ["contentView"],
	    style: {
	      height: _vm.deviceHeight,
	      top: _vm.contentTop
	    }
	  }, [_c('slider-neighbor', {
	    staticClass: ["slider-neighbor"],
	    style: {
	      height: _vm.sliderHeight
	    },
	    attrs: {
	      "neighborAlpha": "0.9",
	      "neighborSpace": _vm.neighborSpace,
	      "neighborScale": "0.9",
	      "currentItemScale": "1",
	      "index": _vm.selectIndex
	    },
	    on: {
	      "change": _vm.changeEvent
	    }
	  }, _vm._l((_vm.productList), function(itemProduct) {
	    return _c('div', {
	      on: {
	        "click": _vm.clickEvent
	      }
	    }, [(itemProduct.itemStyle == 1) ? _c('promotion-product-view', {
	      attrs: {
	        "itemProduct": itemProduct
	      }
	    }) : _vm._e(), (itemProduct.itemStyle == 2) ? _c('promotion-wish-lamp-view', {
	      attrs: {
	        "wishLampObject": itemProduct
	      }
	    }) : _vm._e()], 1)
	  })), _c('div', {
	    staticClass: ["bottomTab"],
	    style: {
	      height: _vm.bottomTabHeight
	    }
	  }, [_c('div', {
	    staticClass: ["bottomTabContentBg"]
	  }, _vm._l((_vm.productList), function(itemProduct, index) {
	    return _c('div', {
	      staticClass: ["bottomTextBgDiv"],
	      style: {
	        'backgroundColor': (index == _vm.selectIndex ? _vm.buttonBgSelectColor : _vm.buttonBgColor),
	        height: _vm.bottomTabHeight,
	        width: _vm.bottomTextWidth
	      },
	      on: {
	        "click": function($event) {
	          _vm.buttonClick(index)
	        }
	      }
	    }, [_c('image', {
	      staticClass: ["bottomTabImage"],
	      style: {
	        height: _vm.bottomTabImageHeight,
	        width: _vm.bottomTabImageWidth
	      },
	      attrs: {
	        "src": itemProduct.tabImage
	      }
	    })])
	  }))])], 1)])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ })
/******/ ]);