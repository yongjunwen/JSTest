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
	var __vue_template__ = __webpack_require__(15)
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
	        buttonBgColor: null,
	        bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
	        productList: [{
	            itemStyle: "1",
	            logoName: "华为",
	            name: "您许的愿望已为您备好，华为",
	            brandLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
	            topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "小米",
	            name: "您许的愿望已为您备好，小米",
	            brandLogo: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1052774542,692148190&fm=26&gp=0.jpg",
	            topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "格力",
	            name: "您许的愿望已为您备好，格力",
	            brandLogo: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=572491635,2679502336&fm=26&gp=0.jpg",
	            topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/pic/2013-01-22/927_p56.jpg ",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
	        }, {
	            logoName: "心愿灯",
	            itemStyle: "2",
	            name: "要降价!京东和阿里打价格战:刘强东发飙",
	            brandLogo: "",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t1870/20/2688983380/490055/66145088/5715bc6aN4933b67c.jpg!q70.jpg"
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
	        var platform = this.$getConfig().env.platform;
	        //            获取设备高度
	        var deviceHeight = this.$getConfig().env.deviceHeight;
	        var deviceWidth = this.$getConfig().env.deviceWidth;

	        var height = 750 / deviceWidth * deviceHeight;
	        if (platform === "iOS") {
	            height -= 20;
	        } else if (platform === "Android") {
	            height -= 120;
	        } else {
	            console.log("=没有匹配到=");
	        }
	        this.deviceHeight = height;
	        //                jud.config.deviceHeight;
	        console.log("---------" + this.deviceHeight + "height=" + height + "platform=" + platform);
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
	    "backgroundColor": "#db74c9",
	    "borderRadius": 40,
	    "overflow": "hidden",
	    "height": 60,
	    "width": 200,
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

	exports.default = {
	    data: function data() {
	        return {
	            seeContent: '进去看看',
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
	  }, [_c('text', {
	    staticClass: ["seeText"]
	  }, [_vm._v(_vm._s(_vm.seeContent))])])])])
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
	var __vue_template__ = __webpack_require__(14)
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
	  "slider-item-wish_lamp": {
	    "width": 600,
	    "height": 910,
	    "borderRadius": 10,
	    "overflow": "hidden",
	    "backgroundColor": "rgb(48,131,248)"
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
	  "tipContent": {
	    "color": "#FFFFFF",
	    "fontSize": 26
	  },
	  "topItemContentText": {
	    "marginTop": 38,
	    "fontSize": 40,
	    "color": "#FFFFFF"
	  }
	}

/***/ }),
/* 13 */
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
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
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
	    //        vue子视图引用的话data要写成如下方法样式
	    data: function data() {
	        return {
	            cardTitle: "心愿灯",
	            tipContent: '30天内努力为你备好，请持续关注'
	        };
	    },
	    props: {
	        wishLampObject: {
	            type: Object,
	            default: {}
	        }
	    }
	};
	module.exports = exports["default"];

/***/ }),
/* 14 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["slider-item-wish_lamp"]
	  }, [_c('div', {
	    staticClass: ["topItemContent"]
	  }, [_c('text', {
	    staticClass: ["topItemContentText"]
	  }, [_vm._v(_vm._s(_vm.cardTitle))]), _c('text', {
	    staticClass: ["lineItem"]
	  }, [_vm._v("-·-")]), _c('text', {
	    staticClass: ["tipContent"]
	  }, [_vm._v(_vm._s(_vm.tipContent))])]), _vm._m(0)])
	},staticRenderFns: [function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["contentDiv"]
	  }, [_c('div', [_c('image')])])
	}]}
	module.exports.render._withStripped = true

/***/ }),
/* 15 */
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
	    }, [_c('text', {
	      staticClass: ["bottomText"]
	    }, [_vm._v(_vm._s(itemProduct.logoName))])])
	  }))])], 1)])
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ })
/******/ ]);