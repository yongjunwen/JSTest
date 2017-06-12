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
	  "rootDiv": {
	    "backgroundColor": "#FFFF00"
	  },
	  "bgView": {
	    "width": 750
	  },
	  "bgImage": {
	    "width": 750
	  },
	  "contentView": {
	    "top": 0,
	    "position": "absolute",
	    "width": 750,
	    "justifyContent": "center"
	  },
	  "slider-neighbor": {
	    "top": 0,
	    "width": 750,
	    "height": 940,
	    "alignItems": "center"
	  },
	  "bottomTab": {
	    "marginTop": 10,
	    "height": 90,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "bottomTabContentBg": {
	    "backgroundColor": "rgba(0,0,0,0.7)",
	    "flexDirection": "row",
	    "paddingLeft": 40,
	    "paddingRight": 40,
	    "borderRadius": 40
	  },
	  "bottomTextBgDiv": {
	    "width": 130,
	    "height": 90,
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

	var _PromotionWishLampView = __webpack_require__(11);

	var _PromotionWishLampView2 = _interopRequireDefault(_PromotionWishLampView);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	var modal = jud.requireModule('modal'); //
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
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
	        PromotionProductView: _PromotionProductView2.default,
	        PromotionWishLampView: _PromotionWishLampView2.default,
	        PromotionBottom: _PromotionBottom2.default
	    },
	    data: {
	        test: 'test222',
	        selectIndex: 0,
	        buttonBgSelectColor: "#000000",
	        deviceHeight: 10,
	        sliderHeight: 0,
	        buttonBgColor: null,
	        bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
	        productList: [{
	            itemStyle: "1",
	            logoName: "华为",
	            tabImage: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1496912449&di=1d908831b09e08208c79e53dce78fc73&src=http://pic.qiantucdn.com/58pic/12/38/18/13758PIC4GV.jpg",
	            name: "您许的愿望已为您备好，华为",
	            brandLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
	            topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "小米",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497517343&di=baff522d5450339011176b5c1fea1302&imgtype=jpg&er=1&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_0_96973789D2128229081_23.jpg",
	            name: "您许的愿望已为您备好，小米",
	            brandLogo: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1052774542,692148190&fm=26&gp=0.jpg",
	            topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "格力",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922663211&di=fd30c4a8b7b1ba325925c91cb2a32586&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F12%2F57%2F08%2F92G58PICHbX.jpg",
	            name: "您许的愿望已为您备好，格力",
	            brandLogo: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=572491635,2679502336&fm=26&gp=0.jpg",
	            topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/pic/2013-01-22/927_p56.jpg ",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
	        }, {
	            logoName: "心愿灯",
	            itemStyle: "2",
	            tabImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg",
	            name: "要降价!京东和阿里打价格战:刘强东发飙",
	            brandLogo: "",
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

	        var height = 750 / deviceWidth * deviceHeight;

	        var sliderHeight = 940;
	        //            var sliderHeight = 940 * deviceWidth / 750;

	        //            var sliderHeight =   750 * (750/940);
	        this.sliderHeight = sliderHeight;

	        //            设备类型匹配
	        if (platform === "ios") {
	            height -= 20;
	            console.log("=匹配到=iOS");
	        } else if (platform === "android") {
	            height -= 200;
	            console.log("=匹配到=Android");
	        } else {
	            console.log("=没有匹配到=");
	        }
	        this.deviceHeight = height;

	        console.log("*==处理后" + this.deviceHeight + "height=" + height + "platform=" + platform);
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
	var __vue_template__ = __webpack_require__(10)
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
/***/ (function(module, exports) {

	'use strict';

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
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
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
	    data: function data() {
	        return {
	            seeContent: '进去看看',
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
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 10 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rootDiv"]
	  }, [_c('div', {
	    staticClass: ["slider-item"]
	  }, [_c('div', {
	    staticClass: ["topItemBg"]
	  }, [_c('image', {
	    staticClass: ["topItemBgImage"],
	    attrs: {
	      "src": _vm.itemProduct.topPic
	    }
	  }), _c('div', {
	    staticClass: ["topItemContent"]
	  }, [_c('image', {
	    staticStyle: {
	      width: "212px",
	      height: "70px",
	      backgroundColor: "aquamarine",
	      marginTop: "18px"
	    },
	    attrs: {
	      "src": _vm.itemProduct.brandLogo
	    }
	  }), _c('text', {
	    staticClass: ["lineItem"]
	  }, [_vm._v("-·-")]), _c('text', {
	    staticClass: ["topItemContentText"]
	  }, [_vm._v(_vm._s(_vm.topContentText))])])]), _c('image', {
	    staticClass: ["bottom-image"],
	    attrs: {
	      "src": _vm.itemProduct.pic
	    }
	  })]), _c('div', {
	    staticClass: ["bottomDiv"],
	    staticStyle: {
	      justifyContent: "center",
	      alignItems: "center"
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
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(12)
	)

	/* script */
	__vue_exports__ = __webpack_require__(13)

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
/* 12 */
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
	    "marginTop": 56,
	    "fontSize": 40,
	    "color": "#FFFFFF"
	  },
	  "lineItem": {
	    "marginTop": 22,
	    "fontSize": 26,
	    "color": "#FFFFFF"
	  },
	  "tipContent": {
	    "marginTop": 34,
	    "color": "#FFFFFF",
	    "fontSize": 26
	  },
	  "contentDiv": {
	    "position": "absolute",
	    "top": 0
	  },
	  "bottomTipContent": {
	    "marginTop": 40,
	    "color": "#FFFFFF",
	    "fontSize": 26
	  }
	}

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionWishLampItemView = __webpack_require__(14);

	var _PromotionWishLampItemView2 = _interopRequireDefault(_PromotionWishLampItemView);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	exports.default = {
	    components: {
	        PromotionWishLampItemView: _PromotionWishLampItemView2.default
	    },
	    //        vue子视图引用的话data要写成如下方法样式
	    data: function data() {
	        return {
	            cardTitle: "心愿灯",
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

	module.exports = exports["default"];

/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(15)
	)

	/* script */
	__vue_exports__ = __webpack_require__(16)

	/* template */
	var __vue_template__ = __webpack_require__(17)
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
/* 15 */
/***/ (function(module, exports) {

	module.exports = {
	  "lampItem": {
	    "width": 132
	  },
	  "lampIconBg": {
	    "width": 132,
	    "height": 144,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "lampIcon": {
	    "width": 132,
	    "height": 144
	  },
	  "lampButtonBg": {
	    "marginTop": 14,
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
/* 16 */
/***/ (function(module, exports) {

	'use strict';

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
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
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
	            cardTitle: "心愿灯",
	            lampText: '点亮',
	            wishLampIcon: "wish_lamp_icon.png",
	            withLampButtonIcon: "wish_lamp_button.png",
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
	                } else if (this.wishLampItem.lampState === '3') {
	                    this.lampText = "已变灰";
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
	    methods: {
	        clickLampEvent: function clickLampEvent() {
	            //                lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
	            //                如果lampState是2 || 3直接return掉 因为 点亮后不再允许再点亮
	            if (this.wishLampItem.lampState === '2' || this.wishLampItem.lampState === '3') {
	                console.log('==已经不能再点击了');
	                //                    todo:show alert 不允许再点亮许愿灯文案提示  具体待向产品确认
	                modal.confirm({ message: "已经点亮，不允许再点亮许愿灯", okTitle: "确认", cancelTitle: '取消' });
	                return;
	            }
	            console.log('=======clickLampEvent======');
	            //                this.lampText = "已点亮";
	            //                this.wishLampItem.lampState = '2'; //todo:同时通知其他变成3的状态

	            this.$emit('changeLampState', this.wishLampItem.brandId);
	        }
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 17 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rootDiv"]
	  }, [_c('div', {
	    staticClass: ["lampItem"],
	    on: {
	      "click": function($event) {
	        _vm.clickLampEvent()
	      }
	    }
	  }, [_c('div', {
	    staticClass: ["lampIconBg"]
	  }, [_c('image', {
	    staticClass: ["lampIcon"],
	    attrs: {
	      "src": _vm.wishLampIcon
	    }
	  }), _c('div', {
	    staticStyle: {
	      position: "absolute",
	      top: "0",
	      justifyContent: "center",
	      alignItems: "center",
	      width: "132px",
	      height: "144px"
	    }
	  }, [_c('image', {
	    staticClass: ["brandLogo"],
	    staticStyle: {
	      backgroundColor: "rosybrown",
	      width: "96px",
	      height: "60px"
	    },
	    attrs: {
	      "src": _vm.wishLampItem.brandIcon
	    }
	  })])]), _c('div', {
	    staticClass: ["lampButtonBg"]
	  }, [_c('image', {
	    staticClass: ["lampButtonIcon"],
	    attrs: {
	      "src": _vm.withLampButtonIcon
	    }
	  }), _c('div', {
	    staticStyle: {
	      position: "absolute",
	      top: "0",
	      justifyContent: "center",
	      alignItems: "center",
	      width: "132px",
	      height: "46px"
	    }
	  }, [_c('text', {
	    staticClass: ["lanmpButtonText"]
	  }, [_vm._v(_vm._s(_vm.lampText))])])])])])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }),
/* 18 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["rooDiv"]
	  }, [_c('div', {
	    staticClass: ["bgImageDiv"]
	  }, [_c('image', {
	    staticClass: ["bgImage"],
	    attrs: {
	      "src": _vm.wishLampBg
	    }
	  })]), _c('div', {
	    staticClass: ["contentDiv"]
	  }, [_c('div', {
	    staticClass: ["topItemContent"]
	  }, [_c('div', {
	    staticStyle: {
	      alignItems: "center",
	      justifyContent: "center"
	    }
	  }, [_c('text', {
	    staticClass: ["topItemContentText"]
	  }, [_vm._v(_vm._s(_vm.cardTitle))]), _c('text', {
	    staticClass: ["lineItem"]
	  }, [_vm._v("-·-")]), _c('text', {
	    staticClass: ["tipContent"]
	  }, [_vm._v(_vm._s(_vm.tipContent))])])]), _c('div', {
	    staticStyle: {
	      flexDirection: "row",
	      marginLeft: "62px"
	    }
	  }, [_c('div', {
	    staticStyle: {
	      marginTop: "60px"
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
	      marginTop: "50px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[3]
	    }
	  }) : _vm._e()], 1), _c('div', {
	    staticStyle: {
	      marginTop: "120px",
	      marginLeft: "43px"
	    }
	  }, [(_vm.wishLampObject.brandList[1]) ? _c('promotion-wish-lamp-item-view', {
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[1]
	    }
	  }) : _vm._e(), (_vm.wishLampObject.brandList[4]) ? _c('promotion-wish-lamp-item-view', {
	    staticStyle: {
	      marginTop: "50px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[4]
	    }
	  }) : _vm._e()], 1), _c('div', {
	    staticStyle: {
	      marginTop: "30px",
	      marginLeft: "43px"
	    }
	  }, [(_vm.wishLampObject.brandList[2]) ? _c('promotion-wish-lamp-item-view', {
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[2]
	    }
	  }) : _vm._e(), (_vm.wishLampObject.brandList[5]) ? _c('promotion-wish-lamp-item-view', {
	    staticStyle: {
	      marginTop: "50px"
	    },
	    attrs: {
	      "wishLampItem": _vm.wishLampObject.brandList[5]
	    }
	  }) : _vm._e()], 1)]), _c('div', {
	    staticClass: ["bottom"],
	    staticStyle: {
	      width: "610px"
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
/* 19 */
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
	      height: _vm.deviceHeight
	    }
	  }, [_c('slider-neighbor', {
	    staticClass: ["slider-neighbor"],
	    style: {
	      height: _vm.sliderHeight
	    },
	    attrs: {
	      "neighborAlpha": "0.9",
	      "neighborSpace": "55",
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
	    staticClass: ["bottomTab"]
	  }, [_c('div', {
	    staticClass: ["bottomTabContentBg"]
	  }, _vm._l((_vm.productList), function(itemProduct, index) {
	    return _c('div', {
	      staticClass: ["bottomTextBgDiv"],
	      style: {
	        'backgroundColor': (index == _vm.selectIndex ? _vm.buttonBgSelectColor : _vm.buttonBgColor)
	      },
	      on: {
	        "click": function($event) {
	          _vm.buttonClick(index)
	        }
	      }
	    }, [_c('image', {
	      staticClass: ["bottomTabImage"],
	      staticStyle: {
	        width: "100px",
	        height: "70px"
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