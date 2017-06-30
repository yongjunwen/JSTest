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
	var __vue_template__ = __webpack_require__(24)
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
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "bottomTab": {
	    "marginTop": 40,
	    "justifyContent": "center",
	    "alignItems": "center"
	  },
	  "bottomTabContentBg": {
	    "backgroundColor": "rgba(0,0,0,0.3)",
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

	var _stringify = __webpack_require__(3);

	var _stringify2 = _interopRequireDefault(_stringify);

	var _PromotionBottom = __webpack_require__(6);

	var _PromotionBottom2 = _interopRequireDefault(_PromotionBottom);

	var _PromotionProductView = __webpack_require__(10);

	var _PromotionProductView2 = _interopRequireDefault(_PromotionProductView);

	var _PromotionWishLampView = __webpack_require__(16);

	var _PromotionWishLampView2 = _interopRequireDefault(_PromotionWishLampView);

	var _PromotionUtil = __webpack_require__(13);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	var _PDBus = __webpack_require__(14);

	var _PDBus2 = _interopRequireDefault(_PDBus);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	var communicate = jud.requireModule('communicate'); //
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	var mta = jud.requireModule('mta');

	var modal = jud.requireModule('modal');
	exports.default = {
	    //        组件注册
	    components: {
	        PromotionProductView: _PromotionProductView2.default,
	        PromotionWishLampView: _PromotionWishLampView2.default,
	        PromotionBottom: _PromotionBottom2.default
	    },
	    //        数据
	    data: {
	        test: 'test222',
	        encodedActivityId: null,
	        isHaveLightened: false,
	        contentTop: 0,
	        selectIndex: 0,
	        neighborSpace: 0,
	        brandItemBgWidth: 0,
	        buttonBgSelectColor: "#000000",
	        deviceHeight: 10,
	        sliderHeight: 0,

	        bottomTabHeight: 0,
	        bottomTextWidth: 0,

	        bottomTabImageHeight: 0,
	        bottomTabImageWidth: 0,
	        buttonBgColor: null,

	        wishLampCopy: null,
	        //            bgImage: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657297580&di=65b23dc612d8be5a0c5d1ec3677e3878&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F18%2F48%2F27%2F5627c379d629c_1024.jpg",
	        bgImage: 'slider_bg_image.png',
	        productList: []
	    },
	    //        方法
	    methods: {

	        //底部tab按钮点击事件
	        buttonClick: function buttonClick(index) {
	            this.selectIndex = index;
	            this.addTabSelectMta(index);
	        },

	        addTabSelectMta: function addTabSelectMta(index) {
	            //埋点
	            //                page_id_param_event_id_param_next
	            //               分别是： pageName,pageId,pageParam,eventName,eventId,eventParam,nextPageName
	            var item = this.productList[index];
	            var srv = item.srv; //todo:底部tab相应的srv ？
	            mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "", "addTabSelectMta", "CustomMade_ActCardFooter", srv, "");
	        },
	        addCardSlideMta: function addCardSlideMta(index) {
	            var item = this.productList[index];
	            var srv = item.srv;
	            mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "", "addCardSlideMta", "CustomMade_ActCardSlide", srv, "");
	        },
	        // 滑动组件change事件
	        changeEvent: function changeEvent(e) {
	            var selectIndexStr = e["index"];

	            //                modal.toast({
	            //                    message: selectIndexStr,
	            //                    duration: 1.8
	            //                })

	            this.selectIndex = Number(selectIndexStr);
	            //添加滑动埋点
	            this.addCardSlideMta(selectIndexStr);
	        },

	        /*
	         获取品牌列表和心愿灯列表的网络请求
	         预发：http:// beta-api.m.jd.com/client.action
	         */
	        fetchList: function fetchList() {
	            var _this = this;
	            //                var reqBody = new Dictionary();
	            //                dictionary.set('encodedActivityId', "47fWAZihZPCoKesZmyPrDD8QokKG");
	            communicate.send("kBrandPromotionHomeCallBack", {
	                "domain": "request",
	                "info": "qryExclusiveDiscount",
	                "params": {
	                    "functionId": "qryExclusiveDiscount",
	                    "body": null
	                }
	            }, function (result) {
	                var str = (0, _stringify2.default)(result);
	                console.log('qryExclusiveDiscount-backData:' + str);
	                console.log('qryExclusiveDiscount-backData:' + result.toString());
	                console.log('qryExclusiveDiscount-backData-code:' + result.code);
	                if (String(result.code) === '0') {

	                    _this.encodedActivityId = result.encodedActivityId;
	                    //                            页面大背景图
	                    _this.bgImage = result.head.bgPic;
	                    //                            心愿灯上部文案是wishLampCopy
	                    _this.wishLampCopy = result.head.wishLampCopy;
	                    //1、如果品牌列表有数据
	                    var _proList = result.brands;
	                    if (_proList.length) {

	                        _this.productList = _proList.slice(0, 4);
	                        _this.productList.forEach(function (item, index) {
	                            console.log('forEach=' + item['brandId']);
	                            if (typeof item.itemStyle == 'undefined') {
	                                console.log('注册中 =====');
	                                //全局注册
	                                Vue.set(item, "itemStyle", "1");
	                            }
	                        });
	                    }

	                    //2、如果心愿灯列表有数据
	                    var _wishLamps = result.wishLamps;
	                    if (_wishLamps.length) {
	                        console.log('心愿灯=======有货');
	                        //                           lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
	                        //                           1、 首先遍历出是否已经点亮的逻辑
	                        for (var i = 0; i < _wishLamps.length; i++) {
	                            var wishItem = _wishLamps[i];
	                            if (wishItem.lightened) {
	                                _this.isHaveLightened = true;
	                                console.log('第一次获取心愿灯=======已经存在点亮');
	                                break;
	                            }
	                        }
	                        //                            2、从上面的是否点亮逻辑来重新添加规划属性
	                        _wishLamps.forEach(function (item, index) {
	                            if (typeof item.lampState == 'undefined') {
	                                console.log('lampState =====');

	                                var stateString = '1';
	                                if (_this.isHaveLightened) {
	                                    if (item.lightened) {
	                                        stateString = '2';
	                                    } else {
	                                        stateString = '3';
	                                    }
	                                } else {
	                                    stateString = '1';
	                                }

	                                //全局注册
	                                Vue.set(item, "lampState", stateString);
	                            }
	                        });

	                        var wishLampDict = {
	                            'itemStyle': '2',
	                            'btmLogo': "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496922709466&di=6d896346a90c4aa1c9bc6cbf81686781&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F30%2F48%2F30p58PICNc5.jpg",
	                            'tabName': "心愿灯",
	                            'wishLampCopy': _this.wishLampCopy,
	                            'brandList': _wishLamps
	                        };

	                        console.log('_wishLamps=======已添加');
	                        _this.productList.push(wishLampDict);
	                    }
	                } else {
	                    console.log('code非0返回状态======sendErrorToNative');
	                    _this.sendErrorToNative();
	                }

	                //返回成功但是暂无数据情况
	                if (_this.productList.length == 0) {
	                    console.log('返回成功但是暂无数据情况=======sendErrorToNative');
	                    _this.sendErrorToNative();
	                }
	            });
	        },

	        //点击品牌跳转到详情页面事件
	        clickBrandEvent: function clickBrandEvent(index) {
	            console.log('clickBrandEvent=====jumpToBrand');
	            //需要传给详情页面的入参
	            var materialIds = [];
	            for (var i = 0; i < this.productList.length; i++) {
	                var item = this.productList[i];
	                if (item.itemStyle == '1') {
	                    materialIds.push(item.materialId);
	                }
	            }

	            console.log('clickBrandEvent=====');
	            //                var dictionary = new Dictionary();
	            //                dictionary.set('selectIndex', index);
	            //                dictionary.set('materialIds', materialIds);
	            //                dictionary.set('activityId', this.activityId);

	            //                发送到原生去跳转到详情
	            communicate.send("kBrandPromotionHomeCallBack", {
	                "domain": "jump",
	                "info": "toBrandDetail",
	                "params": {
	                    "body": {
	                        'selectIndex': index,
	                        'materialIds': materialIds,
	                        'encodedActivityId': this.encodedActivityId
	                    }
	                }
	            }, function (result) {});
	            //添加跳转到原生的埋点
	            //                page_id_param_event_id_param_next
	            //               分别是： pageName,pageId,pageParam,eventName,eventId,eventParam,nextPageName
	            var item = this.productList[index];
	            var srv = item.srv;
	            mta.page_id_param_event_id_param_next("PromotionHome", "Discount_Out", "", "点击品牌到详情事件", "CustomMade_ActCard", srv, "");
	        },
	        //            发送错误信息到native
	        sendErrorToNative: function sendErrorToNative() {
	            communicate.send("kBrandPromotionHomeCallBack", {
	                "domain": "error",
	                "info": "qryExclusiveDiscount",
	                "params": null
	            }, function (result) {});
	        }
	    },
	    //        生命周期created函数 不要写在metods体内
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
	            this.contentTop = 210;
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
	        this.brandItemBgWidth = _PromotionUtil2.default.scale(this) * 606;

	        // 添加网络请求逻辑
	        this.fetchList();
	    },
	    destroyed: function destroyed() {
	        //页面销毁调用事件
	        console.log("destroyed-=========");
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

	module.exports = { "default": __webpack_require__(4), __esModule: true };

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

	var core  = __webpack_require__(5)
	  , $JSON = core.JSON || (core.JSON = {stringify: JSON.stringify});
	module.exports = function stringify(it){ // eslint-disable-line no-unused-vars
	  return $JSON.stringify.apply($JSON, arguments);
	};

/***/ }),
/* 5 */
/***/ (function(module, exports) {

	var core = module.exports = {version: '2.4.0'};
	if(typeof __e == 'number')__e = core; // eslint-disable-line no-undef

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(7)
	)

	/* script */
	__vue_exports__ = __webpack_require__(8)

	/* template */
	var __vue_template__ = __webpack_require__(9)
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
/* 7 */
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
/* 8 */
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
	                hitCopy: null
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
/* 9 */
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
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(11)
	)

	/* script */
	__vue_exports__ = __webpack_require__(12)

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
/* 11 */
/***/ (function(module, exports) {

	module.exports = {
	  "slider-item": {
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
	  },
	  "brandinfo": {
	    "marginTop": 22,
	    "flexDirection": "row",
	    "marginBottom": 50
	  },
	  "brandtext-p": {
	    "flex": 0.8,
	    "maxWidth": 448
	  },
	  "brandtexticon-p": {
	    "flex": 0.1,
	    "width": 39
	  },
	  "brandtext": {
	    "fontSize": 30,
	    "color": "#ffffff",
	    "maxWidth": 448,
	    "textAlign": "center",
	    "verticalAlign": "center",
	    "paddingTop": 0
	  },
	  "brandtexticonleft": {
	    "position": "absolute",
	    "width": 9,
	    "height": 20,
	    "left": 0,
	    "top": 5,
	    "marginRight": 20
	  },
	  "brandtexticonright": {
	    "position": "absolute",
	    "bottom": 0,
	    "right": 0,
	    "width": 9,
	    "height": 20,
	    "marginLeft": 20
	  }
	}

/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionUtil = __webpack_require__(13);

	var _PromotionUtil2 = _interopRequireDefault(_PromotionUtil);

	var _PDBus = __webpack_require__(14);

	var _PDBus2 = _interopRequireDefault(_PDBus);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	var communicate = jud.requireModule('communicate'); //
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
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
	            curveImage: '/img/promotion_rectagle_icon.png',
	            seperateicon: '/img/promotion_seperation_icon.png',
	            brandRootHeight: 0,
	            brandItemHeight: 0,
	            brandItemWidth: 0,
	            topItemBgHeight: 0,
	            brandLogoHeight: 0,
	            brandLogoWidth: 0,
	            brandItemBottomImageHeight: 0,

	            brandItemCurveHeight: 0,
	            seeButtonImage: '/img/see_button.png',
	            topContentText: '[加入我们，创建未来]',
	            topName: '',
	            topContent: '',

	            //                brandtexticonleft: '/img/zs_d_icon_06_left.png',
	            //                brandtexticonright: '/img/zs_d_icon_06_right.png',
	            brandtexticonleft: 'https://h5.m.jd.com/dev/36dSd8yihgQ6pgqyBubDq6e8yPtM/pages/76035/img/zs_d_icon_06_left.png',
	            brandtexticonright: 'https://h5.m.jd.com/dev/36dSd8yihgQ6pgqyBubDq6e8yPtM/pages/76035/img/zs_d_icon_06_right.png'
	        };
	    },
	    props: {
	        itemProduct: {
	            type: Object,
	            default: {}
	        },

	        parentList: {
	            type: Object,
	            default: {}
	        },

	        activityId: {
	            type: Object,
	            default: {}
	        },

	        selectIndex: {
	            type: Object,
	            default: {}
	        },
	        clickBrandEvent: {
	            type: Function
	        }
	    },
	    methods: {
	        clickBrandEvent: function clickBrandEvent() {
	            console.log('clickBrandEvent=====0');
	            //需要传给详情页面的入参
	            var materialIds = [];
	            for (var i = 0; i < this.parentList.length; i++) {
	                var item = this.parentList[i];
	                if (item.itemStyle == '1') {
	                    materialIds.push(item.materialId);
	                }
	            }

	            console.log('clickBrandEvent=====' + materialIds);
	            //                var dictionary = new Dictionary();
	            //                dictionary.set('selectIndex', index);
	            //                dictionary.set('materialIds', materialIds);
	            //                dictionary.set('activityId', this.activityId);

	            communicate.send("kBrandPromotionHomeCallBack", {
	                "domain": "jump",
	                "info": "toBrandDetail",
	                "params": {
	                    "body": {
	                        'selectIndex': this.selectIndex,
	                        'materialIds': materialIds,
	                        'activityId': this.activityId
	                    }
	                }
	            }, function (result) {});
	        },
	        toSeeClick: function toSeeClick() {
	            console.log('--------toSeeClick----+++');
	            //                this.clickBrandEvent();
	            //                console.log(this.clickBrandEvent());
	            this.$emit('kClickBrand');
	            //                 触发组件 A 中的事件
	            //                bus.$emit('id-selected', 1)
	        }
	    },
	    created: function created() {
	        console.log("品牌卡片开始创建");
	        this.brandRootHeight = _PromotionUtil2.default.getSliderHeight(this);
	        this.brandItemHeight = _PromotionUtil2.default.getBrandItemHeight(this);
	        this.brandItemWidth = _PromotionUtil2.default.getBrandItemWidth(this);
	        this.topItemBgHeight = _PromotionUtil2.default.getBrandItemTopBgHeight(this);

	        this.brandItemCurveHeight = _PromotionUtil2.default.getBrandItemCurveHeigh(this);

	        this.brandLogoHeight = _PromotionUtil2.default.getBrandLogoHeight(this);
	        this.brandLogoWidth = _PromotionUtil2.default.getBrandLogoWidth(this);

	        this.brandItemBottomImageHeight = _PromotionUtil2.default.getBrandBottomImageHeight(this);

	        var nameArray = this.itemProduct.name.split("%");
	        this.topName = nameArray[0];
	        this.topContent = nameArray[1];
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 13 */
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

	        var statusBarH = 0;
	        if (platform === "ios") {
	            statusBarH = 0;
	        } else if (platform === "android") {
	            //40为减去状态栏的高度 默认使用40
	            statusBarH = 40;
	        }

	        //            获取屏幕布局高度
	        return 750 / deviceWidth * (deviceHeight - statusBarH);
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
	        return 606 * this.scale(_this);
	        ;
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
/* 14 */
/***/ (function(module, exports) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []
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
	__vue_options__.__file = "/Users/wenyongjun/private_workspace/JSTestFolder/jud-ios/assets/PDBus.vue"
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
	      "src": _vm.itemProduct.titleAtmoPic,
	      "placeholder": "native://zs_detail_brand_placeholder"
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
	      marginTop: "18px"
	    },
	    style: {
	      height: _vm.brandLogoHeight,
	      width: _vm.brandLogoWidth
	    },
	    attrs: {
	      "placeholder": "native://zs_detail_brand_placeholder"
	    }
	  }), _c('image', {
	    staticClass: ["seperateicon"],
	    attrs: {
	      "src": _vm.seperateicon
	    }
	  }), _c('div', {
	    staticClass: ["brandinfo"]
	  }, [_c('div', {
	    staticClass: ["brandtexticon-p"]
	  }), _c('div', {
	    staticClass: ["brandtext-p"]
	  }, [_c('text', {
	    staticClass: ["brandtext"]
	  }, [_vm._v(_vm._s(_vm.topName))]), _c('text', {
	    staticClass: ["brandtext"]
	  }, [_vm._v(_vm._s(_vm.topContent))])]), _c('div', {
	    staticClass: ["brandtexticon-p"]
	  }), _c('image', {
	    staticClass: ["brandtexticonleft"],
	    attrs: {
	      "src": _vm.brandtexticonleft
	    }
	  }), _c('image', {
	    staticClass: ["brandtexticonright"],
	    attrs: {
	      "src": _vm.brandtexticonright
	    }
	  })])]), _c('div', {
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
	      "src": _vm.itemProduct.middlePic,
	      "placeholder": "native://zs_detail_brand_placeholder"
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
	  }, [_vm._v(_vm._s(_vm.itemProduct.hitCopy))]), _c('div', {
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
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(17)
	)

	/* script */
	__vue_exports__ = __webpack_require__(18)

	/* template */
	var __vue_template__ = __webpack_require__(23)
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
/* 17 */
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
/* 18 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionWishLampItemView = __webpack_require__(19);

	var _PromotionWishLampItemView2 = _interopRequireDefault(_PromotionWishLampItemView);

	var _PromotionUtil = __webpack_require__(13);

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
	//
	//
	//
	//

	var communicate = jud.requireModule('communicate');
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
	            seperateicon: '/img/zs_d_icon_05.png',
	            wishLampBg: "/img/wish_lamp_bg_image.png",
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

	        //todo: 点亮心愿灯网络请求
	        lightenBrandWishLampEvent: function lightenBrandWishLampEvent(brandId) {
	            var _this = this;
	            console.log('lightenBrandWishLampEvent==brandId' + brandId);
	            communicate.send("kBrandPromotionHomeCallBack", {
	                "domain": "request",
	                "info": "lightenBrandWishLamp",
	                "params": {
	                    "functionId": "lightenBrandWishLamp",
	                    "body": { 'brandId': brandId }
	                }
	            }, function (result) {

	                if (String(result.code) === '0') {
	                    console.log("lightenBrandWishLampEvent------===请求成功");
	                    //表示请求成功
	                    //                            _this.updateLampData();
	                    _this.wishLampObject.brandList.forEach(function (item, index) {
	                        console.log('brandId=' + item['brandId']);
	                        if (item['brandId'] === brandId) {
	                            item['lampState'] = '2';
	                            console.log('changeLampStateEvent====lampState=2');
	                        } else {
	                            console.log('changeLampStateEvent====lampState=3');
	                            item['lampState'] = '3';
	                        }
	                    });
	                } else {
	                    communicate.send("kBrandPromotionHomeCallBack", {
	                        "domain": "error",
	                        "info": "lightenBrandWishLamp",
	                        "params": result
	                    }, function (result) {});
	                }
	            });
	        },
	        updateLampData: function updateLampData() {
	            console.log("updateLampData------===");
	            this.wishLampObject.brandList.forEach(function (item, index) {
	                console.log('brandId=' + item['brandId']);
	                if (item['brandId'] === lampItemID) {
	                    item['lampState'] = '2';
	                    console.log('changeLampStateEvent====lampState=2');
	                } else {
	                    console.log('changeLampStateEvent====lampState=3');
	                    item['lampState'] = '3';
	                }
	            });
	        },
	        changeLampStateEvent: function changeLampStateEvent(lampItemID) {
	            console.log('changeLampStateEvent=====' + lampItemID + '获取到');
	            console.log('array=' + this.wishLampObject.brandList);

	            //                todo:添加点亮心愿灯网络请求逻辑
	            this.lightenBrandWishLampEvent(lampItemID);
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
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(20)
	)

	/* script */
	__vue_exports__ = __webpack_require__(21)

	/* template */
	var __vue_template__ = __webpack_require__(22)
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
/* 20 */
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
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	    value: true
	});

	var _PromotionUtil = __webpack_require__(13);

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

	var modal = jud.requireModule('modal');

	var mta = jud.requireModule('mta');
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
	            wishLampNomalIcon: "/img/wish_lamp_normal_icon.png",
	            wishLampSelectIcon: "/img/wish_lamp_select_icon.png",
	            wishLampDisableIcon: "/img/wish_lamp_disable_icon.png",

	            wishLampNomalBtn: "/img/wish_lamp_normal_btn.png",
	            wishLampSelectBtn: "/img/wish_lamp_select_btn.png",
	            wishLampDisableBtn: "/img/wish_lamp_disable_btn.png",

	            tipContent: '30天内努力为你备好，请持续关注',
	            isShowSelect: false,
	            lampPlaceHolderIcon: 'native://wish_lamp_normal_icon.png',
	            wishLampBtnIcon: 'native://wish_lamp_normal_btn.png'
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
	                this.updateLampState();
	            },
	            deep: true
	        }
	    },
	    mounted: function mounted() {
	        console.log("mounted=====wishLampItem");

	        this.updateLampState();
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
	        updateLampState: function updateLampState() {
	            if (this.wishLampItem.lampState === '2') {
	                this.lampText = "已点亮";
	                //                        this.lampTextColor = "#ffb5b7";
	                this.isShowSelect = true;
	                this.lampPlaceHolderIcon = 'native://wish_lamp_select_icon.png';
	                this.wishLampBtnIcon = 'native://wish_lamp_select_btn.png';
	            } else if (this.wishLampItem.lampState === '3') {
	                //                        this.lampText = "已变灰";
	                this.lampTextColor = "#999999";
	                this.brandLogoImageOpacity = 0.5;
	                this.lampPlaceHolderIcon = 'native://wish_lamp_disable_icon.png';
	                this.wishLampBtnIcon = 'native://wish_lamp_disable_btn.png';
	            } else {
	                this.lampPlaceHolderIcon = 'native://wish_lamp_normal_icon.png';
	                this.wishLampBtnIcon = 'native://wish_lamp_normal_btn.png';
	            }
	        },
	        addConfirnClickLampMta: function addConfirnClickLampMta() {
	            var srv = this.wishLampItem.srv;
	            mta.page_id_param_event_id_param_next("PromotionWishLampItemView", "Discount_Out", "", "addConfirnClickLampMta", "CustomMade_WishBrandConfirm", srv, "");
	        },
	        addCancelClickLampMta: function addCancelClickLampMta() {
	            var srv = this.wishLampItem.srv;
	            mta.page_id_param_event_id_param_next("PromotionWishLampItemView", "Discount_Out", "", "addCancelClickLampMta", "CustomMade_WishBrandCancel", srv, "");
	        },
	        addClickLampMta: function addClickLampMta() {
	            //埋点
	            //                page_id_param_event_id_param_next
	            //               分别是： pageName,pageId,pageParam,eventName,eventId,eventParam,nextPageName
	            var srv = this.wishLampItem.srv;
	            mta.page_id_param_event_id_param_next("PromotionWishLampItemView", "Discount_Out", "", "addClickLampMta", "CustomMade_WishBrand", srv, "");
	        },
	        clickLampEvent: function clickLampEvent() {
	            //                lampState 1是正常状态 2是已点亮 3是不可点亮变灰状态
	            //                如果lampState是2 || 3直接return掉 因为 点亮后不再允许再点亮
	            if (this.wishLampItem.lampState === '2' || this.wishLampItem.lampState === '3') {
	                console.log('==已经不能再点击了');
	                //                    todo:show alert 不允许再点亮许愿灯文案提示  具体待向产品确认
	                //                    modal.alert({message: "已经点亮，不允许再点亮许愿灯", okTitle: "确认", cancelTitle: '取消'});
	                return;
	            }
	            //点击埋点
	            this.addClickLampMta();

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
	                    _this.addConfirnClickLampMta();
	                } else {
	                    _this.addCancelClickLampMta();
	                }
	            });
	        }
	    }
	};
	module.exports = exports['default'];

/***/ }),
/* 22 */
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
	  }, [_c('image', {
	    staticClass: ["lampIcon"],
	    style: {
	      height: _vm.lampIconHeight,
	      width: _vm.lampItemWidth
	    },
	    attrs: {
	      "src": _vm.lampPlaceHolderIcon
	    }
	  }), _c('div', {
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
	      "src": _vm.wishLampItem.img
	    }
	  })])]), _c('div', {
	    staticClass: ["lampButtonBg"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampItemWidth
	    }
	  }, [_c('image', {
	    staticClass: ["lampButtonIcon"],
	    style: {
	      height: _vm.lampButtonBgHeight,
	      width: _vm.lampButtonIconWidth
	    },
	    attrs: {
	      "src": _vm.wishLampBtnIcon
	    }
	  }), _c('div', {
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
/* 23 */
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
	  }, [_vm._v(_vm._s(_vm.wishLampObject.wishLampCopy))])])]), _c('div', {
	    staticStyle: {
	      flexDirection: "row"
	    }
	  }, [_c('div', {
	    staticStyle: {
	      marginLeft: "15px"
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
/* 24 */
/***/ (function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return (_vm.productList.length != 0) ? _c('div', {
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
	      "src": _vm.bgImage,
	      "placeholder": "native://slider_bg_image"
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
	  }, _vm._l((_vm.productList), function(itemProduct, index) {
	    return _c('div', {
	      staticStyle: {
	        alignItems: "center",
	        justifyContent: "center"
	      },
	      style: {
	        height: _vm.sliderHeight,
	        width: _vm.brandItemBgWidth
	      }
	    }, [(itemProduct.itemStyle == 1) ? _c('promotion-product-view', {
	      attrs: {
	        "itemProduct": itemProduct
	      },
	      on: {
	        "kClickBrand": function($event) {
	          _vm.clickBrandEvent(index)
	        }
	      }
	    }) : _vm._e(), (itemProduct.itemStyle == 2) ? _c('promotion-wish-lamp-view', {
	      attrs: {
	        "wishLampObject": itemProduct
	      }
	    }) : _vm._e()], 1)
	  })), (_vm.productList.length > 1) ? _c('div', {
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
	        "src": itemProduct.btmLogo
	      }
	    })])
	  }))]) : _vm._e()], 1)]) : _vm._e()
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ })
/******/ ]);