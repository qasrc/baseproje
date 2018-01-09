/*----------------------------------------------------------------
 // Copyright (C) 2010 山东众阳软件公司
 // 版权所有。
 //
 // 文件名：cardcomm.js
 // 文件功能描述：刷卡配置脚本
 //
 //
 // 创建标识：张三元 20161115
 // 创建内容： 系统框架和注释
 //
 // 代码填写： 张三元 20161115

 ----------------------------------------------------------------------*/

//读卡函数
//<param name="inputId">刷卡文本框的id</param>
//<param name="configString">卡配置信息</param>
//<param name="css"></param>
function ReadCardNo(inputId, configString, css) {
    //定义对象
    var othis = this;
    //读卡文本框
    this.inputTextId = inputId;

    //读卡配置
    this.config = configString;
    //卡长度
    this.cardLength = null;
    //卡总长度
    this.cardTotalLength = null;
    //读卡方式个数
    this.count = null;
    //定义数组
    this.arry = null;
    //是否开启位数补齐
    this.fill = null;
    //补齐前缀
    this.preFill = null;
    //是否取消长度限制
    this.isLimt = true;
    //css样式
    this.css = css;

    //卡号文本框 是否限制输入
    this.IsOpenControlInput = "0";
    //限制卡号输入时 每10位卡号允许的最长输入时间；重点说明InputTimeLimit最大值1000，配置中配大于1000的数 按1000计算
    this.InputTimeLimit = 1000;
    //是否删除特殊符号
    this.isDelSpecialCharFromCardNo = "0";

    this.IsOpenManyCards = 0;
    //初始化
    this.init = function () {


        othis.config = eval('(' + othis.config + ')');
        othis.count = othis.config["CardNum"];
        othis.arry = othis.count.split("_");
        othis.cardLength = othis.config["Length"];
        othis.fill = othis.config["POne"];
        othis.preFill = othis.config["PTwo"];
        othis.cardTotalLength = othis.config["TotalLength"];
        othis.getHidFrame();

    };


    //显示框架
    this.getHidFrame = function () {
        if (othis.arry != null) {
            for (var i = 0; i < othis.arry.length; i++) {
                var url = "Url" + othis.arry[i];
                var readtype = "ReadType" + othis.arry[i];
                var showname = "ShowName" + othis.arry[i];
                var cardType = "CardType" + othis.arry[i];
                var arryId = othis.arry[i];
                var containerdiv = $("<div></div>");
                var ifreamhid = $("<iframe>");
                var divcss = {
                    "position": "absolute",
                    "z-index": "100",
                    "display": "none",
                    "overflow": "hidden",
                    "width": "750",
                    "height": "500",
                    "left": "100",
                    "top": "80"
                };
                var ifcss = {
                    "border": "solid 1px blue",
                    "height": "100%",
                    "width": "100%"
                };
                containerdiv.attr("id", "div" + arryId);
                if (othis.config[readtype] == "1") {
                    containerdiv.addClass("divclose");
                }
                containerdiv.css(divcss);
                ifreamhid.css(ifcss);
                ifreamhid.attr("id", "fram" + arryId);
                ifreamhid.attr("src", othis.config[url]);
                containerdiv.append(ifreamhid);
                $(document.body).append(containerdiv);
                othis.SetCardType(readtype, cardType, showname, arryId, url);
            }
        }
    };


    //设置读卡方式
    //<parame name="readType">读卡类型</parame>
    //<parame name="cardType">卡加密方式</parame>
    //<parame name="showName">主动读卡时要显示的名字</parame>
    //<parame name="arryId">编号</arryId>
    //<parame name="url">读卡页面</url>
    this.SetCardType = function (readType, cardType, showName, arryId, url) {

        if (othis.inputTextId == undefined || othis.inputTextId == null) {
            return;
        }

        //主动读卡
        if (othis.config[readType] == "1") {
            // 生成input对象

            var button = document.createElement("input");
            button.type = "button";
            button.id = "btnActive";
            button.value = othis.config[showName];
            document.body.appendChild(button);
            button.attachEvent("onclick", function () {
                $("#div" + arryId).css("display", "block");
                window.frames[("fram" + arryId)].ToReadCard(othis.config[url],
                    ("fram" + arryId), ("div" + arryId), othis.inputTextId, othis.cardLength, othis.isLimt, othis.isDelSpecialCharFromCardNo, othis.IsOpenManyCards)
            });
            //插入到文本框后面
            var inputid = document.getElementById(othis.inputTextId);
            inputid.parentNode.insertBefore(button, inputid.nextSibling);

            document.getElementById(othis.inputTextId).attachEvent('onfocus', function () {
                document.getElementById(othis.inputTextId).select();
            });
        }
        //被动读卡
        if (othis.config[readType] == "2" && othis.inputTextId != undefined && othis.inputTextId != null) {
            //执行被动读卡方法
            document.getElementById(othis.inputTextId).attachEvent('onkeyup', function () {
                window.frames["fram" + arryId].ReadCardPassive(othis.inputTextId, othis.cardLength, othis.isLimt, othis.isDelSpecialCharFromCardNo, othis.IsOpenManyCards);
            });

            document.getElementById(othis.inputTextId).attachEvent('onfocus', function () {
                document.getElementById(othis.inputTextId).select();
            });

        }
        //替换显示
        if (othis.config[readType] == "3") {
            othis.getfrmIndex = arryId;
            //获取文本框长度
            var width = document.getElementById(othis.inputTextId).offsetWidth;
            //获取文本框高度
            var height = document.getElementById(othis.inputTextId).offsetHeight;
            //获取文本框左边距
            var x = document.getElementById(othis.inputTextId).offsetLeft;
            //获取文本框上边距
            var y = document.getElementById(othis.inputTextId).offsetTop;
            //执行替换方法
            window.frames["fram" + arryId].attachEvent("onload", function () {
                window.frames["fram" + arryId].SetCardReplaceShow(x, y, width, height,
                    othis.inputTextId, window, othis.config[cardType], othis.cardLength, othis.fill, othis.preFill, othis.isLimt, othis.css, othis.cardTotalLength, othis.IsOpenControlInput, othis.InputTimeLimit, othis.isDelSpecialCharFromCardNo, othis.IsOpenManyCards);
                if (othis.IsOpenControlInput == "1") {
                    InputControlFun(othis.inputTextId);
                }
                $("#txtOver").focus(function () {
                    $("#txtOver").select();
                })
            });
        }


    };

    //对读卡的文本框光标定位
    this.GetFocus = function () {

        try {
            var inputId = othis.inputTextId;
            if (othis.isHasOver() == true) {
                if (document.getElementById(inputId).nextSibling != null) {
                    if (document.getElementById(inputId).nextSibling.attributes != null) {
                        document.getElementById(inputId).nextSibling.focus();
                        document.getElementById(inputId).nextSibling.select();
                    }
                }

            }
            else {
                if (document.getElementById(inputId).style.display != "none") {
                    document.getElementById(inputId).focus();
                    document.getElementById(inputId).select();
                }
            }
        }
        catch (E) {
        }

    };


    //判断是否是替换显示
    this.isHasOver = function () {
        var result = false;
        if (othis.arry != null) {
            for (var i = 0; i < othis.arry.length; i++) {
                var readtype = "ReadType" + othis.arry[i];
                if (othis.config[readtype] == "3") {
                    result = true;
                    break;
                }
            }
        }
        return result;
    };

    //判断是否是加密卡
    this.encrypted = function () {
        var result = false;
        if (othis.arry != null) {
            for (var i = 0; i < othis.arry.length; i++) {
                var cardtype = "CardType" + othis.arry[i];
                if (othis.config[cardtype] != "CodeCard") {
                    result = true;
                    break;
                }
            }
        }
        return result;
    };
    //判断是否包含主动读卡
    this.isActiveCard = function () {
        var result = false;
        if (othis.arry != null) {
            for (var i = 0; i < othis.arry.length; i++) {
                var readtype = "ReadType" + othis.arry[i];
                if (othis.config[readtype] == "1") {
                    result = true;
                    break;
                }
            }
        }
        return result;
    };
    //主动读卡时隐藏读卡按纽
    this.HidReadButton = function () {
        if (othis.isActiveCard() == true) {
            $("#btnActive").css("display", "none");
        }
    };
    //主动读时显示读卡按纽
    this.ShowReadButton = function () {
        if (othis.isActiveCard() == true) {
            $("#btnActive").css("display", "inline");
        }

    };

    //对读卡的文本框赋值
    //<param name="value">替换的值</param>
    this.OverTextValue = function (value) {
        if (othis.isHasOver() == true) {
            if (document.getElementById(othis.inputTextId).nextSibling != null) {
                if (document.getElementById(othis.inputTextId).nextSibling.attributes != null) {
                    document.getElementById(othis.inputTextId).nextSibling.value = value;
                    document.getElementById(othis.inputTextId).value = value;
                }
            }
        }
        else {
            document.getElementById(othis.inputTextId).value = value;
        }

    };
    //获取文本框的值
    this.GetTextValue = function () {
        var result = "";
        if (othis.isHasOver() == true) {
            if (document.getElementById(othis.inputTextId).nextSibling != null) {
                if (document.getElementById(othis.inputTextId).nextSibling.attributes != null) {
                    result = document.getElementById(othis.inputTextId).nextSibling.value;
                }
            }
        }
        else {
            result = document.getElementById(othis.inputTextId).value;
        }
        return result;

    };

    //隐藏文本框
    this.HideText = function () {
        if (othis.isHasOver() == true) {
            if (document.getElementById(othis.inputTextId).nextSibling != null) {
                if (document.getElementById(othis.inputTextId).nextSibling.style != null) {
                    document.getElementById(othis.inputTextId).nextSibling.style.display = "none";
                }
            }
        }
        else {
            document.getElementById(othis.inputTextId).style.display = "none";
        }

    };
    //显示文本框
    this.ShowText = function () {
        if (othis.isHasOver() == true) {
            if (document.getElementById(othis.inputTextId).nextSibling != null) {
                if (document.getElementById(othis.inputTextId).nextSibling.style != null) {
                    document.getElementById(othis.inputTextId).nextSibling.style.display = "inline";
                }
            }
        }
        else {
            document.getElementById(othis.inputTextId).style.display = "inline";
        }
    };


    //取消卡号长度限制
    this.CancelCardLengthLimit = function () {
        othis.isLimt = false;
    };
    //取消卡号位数补齐
    this.CancelAutoFill = function () {
        if (othis.fill == "bq") {
            othis.fill = "no";
        }

    };
    //设置卡号补齐
    this.SetCardFill = function () {
        othis.fill = "bq";
    };


    this.init();
}