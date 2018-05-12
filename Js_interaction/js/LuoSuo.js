var LS = {};
//app常量
LS.Constants = {
    NET_URL: "http://172.20.0.100", //http://app.lianxi.com",
    INTERFACE_GETAPPTOKEN: "http://172.20.0.100/api_utf/appmanagement/getAppToken.jsp",
    CITY_LIST_ACTION : "",//城市列表ACTION
    OCCUPATION_LIST_ACTION : ""
};
//app数据
LS.Data = {
    appType: 0,
    appToken: ""
};
LS.Page = {
    init : function(a){
        if(a){//设置页面高度 修复IOS7~8的BUG
            this.setBodyTop(a);
        }
        this.initialise && this.initialise();
    },
    setBodyTop : function(a){

    },
    initBodyTop : function () {//设置IOS据顶部距离
        alert("调用成功");
        document.body.style.marginTop = "20px";
    }
};
//app接口
LS.WebAppInterface = {
    //获取appToken
    AppToken: {
        get: function (callBack) {
            if (callBack) {
                LS.WebAppInterface.AppToken.callback = callBack;
            }
            window.lxjs.getToken(LS.Constants.INTERFACE_GETAPPTOKEN, "appType=" + LS.Data.appType, "LS.WebAppInterface.AppToken.set");
        },
        set: function () {
            var r = JSON.parse(arguments[0]);
            LS.Data.appToken = r.appToken;
            LS.WebAppInterface.AppToken.callback && LS.WebAppInterface.AppToken.callback();
            LS.WebAppInterface.AppToken.callback = null;
        },
        callback: null
    },
    //调用原生日期的方法
    Date: {
        get: function (callBack) {
            if (callBack) {
                LS.WebAppInterface.Date.callback = callBack;
            }
            window.lxjs.showDataPicker("LS.WebAppInterface.Date.set");
        },
        set: function () {
            LS.WebAppInterface.Date.callback && LS.WebAppInterface.Date.callback(JSON.parse(arguments[0]));
            LS.WebAppInterface.Date.callback = null;
        },
        callback: null
    },
    //调用原生城市的方法
    City: {
        get: function (callBack){
            if (callBack) {
                LS.WebAppInterface.City.callback = callBack;
            }
            window.lxjs.startActivityResultCallBack("com.tixa.activity.citylist", "LS.WebAppInterface.City.set");
        },
        set: function () {
            var r = JSON.parse(arguments[0]);
            LS.WebAppInterface.City.callback && LS.WebAppInterface.City.callback(r);
            LS.WebAppInterface.City.callback = null;
        },
        callback: null
    },
    //调用原生 --- 行业选择的方法
    Occupation: {
        get: function (callBack){
            if(callBack){
                LS.WebAppInterface.Occupation.callback = callBack;
            }
            window.lxjs.startActivityResultCallBack("com.tixa.activity.occupation", "LS.WebAppInterface.Occupation.set");
        },
        set: function () {
            var r = JSON.parse(arguments[0]);
            LS.WebAppInterface.Occupation.callback && LS.WebAppInterface.Occupation.callback(r);
            LS.WebAppInterface.Occupation.callback = null;
        },
        callback: null
    },
    //调用原生 --- 获取定位信息
    //@param callback 回调函数
    Location : {
        get : function (callBack){
            if(callBack){
                LS.WebAppInterface.Location.callback = callBack;
            }
            window.lxjs.getLocationMessage("LS.WebAppInterface.Location.set");
        },
        set: function () {
            var r = JSON.parse(arguments[0]);
            LS.WebAppInterface.Location.callback && LS.WebAppInterface.Location.callback(r);
            LS.WebAppInterface.Location.callback = null;
        },
        callback: null
    },
    //调用原生属性选择方法 - 弹出选择框
    BottomDialog : {
        get : function (callBack,arr){
            if(arr && Object.prototype.toString.call(arr) == "[object Array]"){
                if(callBack) LS.WebAppInterface.BottomDialog.callback = callBack;
                window.lxjs.showBottomDialog(arr, callback);
            }else{
                //数据类型错误
                return false;
            }
        },
        set : function () {//返回值{"itemContent":"AB型"}
            var r = JSON.parse(arguments[0]);
            LS.WebAppInterface.BottomDialog.callback && LS.WebAppInterface.BottomDialog.callback(r);
            LS.WebAppInterface.BottomDialog.callback = null;
        },
        callback : null
    },
    UserInfo : {
        get : function (callBack){
            if(callBack){
                this.callback = callBack;
            }
            window.lxjs.getUserInfo("LS.WebAppInterface.UserInfo.set");
        },
        set : function () {//返回值{"itemContent":"AB型"}
            var r = JSON.parse(arguments[0]);
            this.callback && this.callback(r);
            this.callback = null
        },
        callback : null
    },

    //直接调用的方法。。没有callback
    NoCallback : {
        goBackApp: function () {
            window.lxjs.goBackApp();
        },
        seeContact: function (accountId) {
            window.lxjs.seeContact(accountId);
        }
    }

};
