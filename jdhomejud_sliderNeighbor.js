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
	__vue_options__.__file = "/Users/wenyongjun/JD/jud/judpack/judpack-ios/bin/templates/assets/jdhomejud_sliderNeighbor.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-4586d76e"
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
	    "height": 1000
	  },
	  "slider-neighbor": {
	    "top": 0,
	    "width": 750,
	    "height": 1000,
	    "alignItems": "center"
	  },
	  "bottomTab": {
	    "marginTop": 30,
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
	        selectIndex: 0,
	        buttonBgSelectColor: "#17031c",
	        deviceHeight: 10,
	        buttonBgColor: null,
	        bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
	        productList: [{
	            itemStyle: "1",
	            logoName: "华为",
	            name: "京东引领未来，iPad团队引领未来",
	            brandLogo: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496753668189&di=a3af9cf6e8a0736098ff56e9ba464e7b&imgtype=0&src=http%3A%2F%2Fpic40.nipic.com%2F20140418%2F11353228_172109208105_2.jpg",
	            topPic: "https://img20.360buyimg.com/da/jfs/t5611/170/1386290369/74627/83bc5dc2/59263308N4c6c741d.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t3226/304/5090006819/188905/a115943a/586078b9N92942b62.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "小米",
	            name: "百草味携手京东high翻“618全民年中购物节”",
	            brandLogo: "",
	            topPic: "https://img1.360buyimg.com/da/jfs/t5878/144/1093343417/94022/3cd88574/5923d027N60c1c8b9.jpg",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2008/329/2598526651/294767/23b295e4/570f2dcdN2cc4a19c.jpg!q70.jpg"
	        }, {
	            itemStyle: "1",
	            logoName: "格力",
	            name: "夏日陪你美翻天!荣耀V9京东点评送好礼  ",
	            brandLogo: "",
	            topPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1496644651&di=472e2fbb406dadcc758f19f6228be092&src=http://images.ali213.net/picfile/pic/2013-01-22/927_p56.jpg ",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t2287/140/2518661178/69983/61cb59dc/570e1db2Nf5b0ebe3.jpg!q70.jpg"
	        }, {
	            logoName: "Apple",
	            itemStyle: "2",
	            name: "要降价!京东和阿里打价格战:刘强东发飙",
	            brandLogo: "",
	            pic: "https://m.360buyimg.com/mobilecms/s400x400_jfs/t1870/20/2688983380/490055/66145088/5715bc6aN4933b67c.jpg!q70.jpg"
	        }]
	    },
	    methods: {

	        buttonClick: function buttonClick(index) {
	            this.selectIndex = index;
	            this.$getConfig().env.deviceWidth;
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
	        //            获取设备高度
	        this.deviceHeight = this.$getConfig().env.deviceHeight;
	        //                jud.config.deviceHeight;
	        console.log("---------" + this.deviceHeight);
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
	__vue_options__.__file = "/Users/wenyongjun/JD/jud/judpack/judpack-ios/bin/templates/assets/PromotionBottom.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-50428622"
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
	__vue_options__.__file = "/Users/wenyongjun/JD/jud/judpack/judpack-ios/bin/templates/assets/PromotionProductView.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-3585dd66"
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
	  "slider-item": {
	    "width": 600,
	    "height": 946,
	    "backgroundColor": "#FF0000",
	    "borderRadius": 10,
	    "overflow": "hidden"
	  },
	  "topItemBg": {
	    "width": 600,
	    "height": 260
	  },
	  "topItemBgImage": {
	    "width": 600,
	    "height": 260,
	    "borderTopLeftRadius": 10,
	    "borderTopRightRadius": 10
	  },
	  "bottom-image": {
	    "marginLeft": 0,
	    "marginRight": 0,
	    "width": 600,
	    "height": 650
	  },
	  "topItemContent": {
	    "top": 0,
	    "width": 600,
	    "alignItems": "center",
	    "justifyContent": "center",
	    "position": "absolute"
	  },
	  "topItemContentText": {
	    "fontSize": 20,
	    "color": "#FFFFFF"
	  }
	}

/***/ }),
/* 9 */
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
	//
	//
	//
	//
	//
	//
	//

	exports.default = {
	    data: {},
	    props: {
	        itemProduct: {
	            type: Object,
	            default: {}
	        }
	    }
	};
	module.exports = exports["default"];

/***/ }),
/* 10 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
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
	      backgroundColor: "aquamarine"
	    },
	    attrs: {
	      "src": _vm.itemProduct.brandLogo
	    }
	  }), _c('text', {
	    staticClass: ["topItemContentText"]
	  }, [_vm._v("[加入我们，创建未来]")])])]), _c('text', {
	    staticClass: ["text"]
	  }, [_vm._v(_vm._s(_vm.itemProduct.name))]), _c('image', {
	    staticClass: ["bottom-image"],
	    attrs: {
	      "src": _vm.itemProduct.pic
	    }
	  })])
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
	__vue_options__.__file = "/Users/wenyongjun/JD/jud/judpack/judpack-ios/bin/templates/assets/PromotionWishLampView.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-04f2569b"
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
	    "height": 946,
	    "backgroundColor": "#008000"
	  },
	  "text": {
	    "marginTop": 10,
	    "marginLeft": 10,
	    "marginRight": 10,
	    "fontSize": 20,
	    "height": 40,
	    "color": "#000000"
	  },
	  "image": {
	    "marginLeft": 10,
	    "marginRight": -10,
	    "width": 580,
	    "height": 580,
	    "resize": "stretch"
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

	exports.default = {
	    data: {},
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
	  }, [_c('text', {
	    staticClass: ["text"]
	  }, [_vm._v(_vm._s(_vm.wishLampObject.name))])])
	},staticRenderFns: []}
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
	    staticClass: ["contentView"]
	  }, [_c('slider-neighbor', {
	    staticClass: ["slider-neighbor"],
	    attrs: {
	      "interval": "0",
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