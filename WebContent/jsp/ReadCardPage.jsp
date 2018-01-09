<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/commons/global.jsp" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <%@ include file="/commons/basejs.jsp" %>

    <%--<script type="text/javascript" src="${staticPath }/jsp/scripts/jquery.min.js"></script>--%>
    <script type="text/javascript" src="${staticPath }/jsp/scripts/md5-min.js"></script>
    <script type="text/javascript">
        var CardTypeReplace = "";
        var i = 0;
        var j = 0;
        var cardLength;
        var cardNo = "";
        var cardNumber = "";
        var flagLimt;
        var totalLength;
        var IsIputEnter = 0;
        var IsClearAndReTime = 0;
        var timeobj = null;
        //限制卡号输入时, 每10位卡号允许的最长输入时间；重点说明InputTimeLimit最大值1000，配置中配大于1000的数 按1000计算
        var InputTimeLimit = "1000";
        var icountRCP = 0;//本页面统计特殊函数调用次数
        //卡号文本框 是否限制输入
        var IsOpenControlInput = "0";
        //是否删除  卡号中字符
        var isDelSpecialChar = "0";
        //主动读卡调用方法
        function ToReadCard(url, fram) {
            var iframeDiv = parent.document.getElementsByTagName("div");
            for (var i = 0; i < iframeDiv.length; i++) {
                if (iframeDiv[i].className && iframeDiv[i].className == "divclose") {
                    iframeDiv[i].style.display = "none";
                    break;
                }
            }
        }

        //被动读卡调用方法
        function ReadCardPassive(cardInput, length, isLimt, isDelSpecialCharFromCardNo, isOpenManyCards) {
            parent.document.getElementById(cardInput).value = DelSpecialCharFromCardNo(parent.document.getElementById(cardInput).value, isDelSpecialCharFromCardNo);
            flagLimt = isLimt;
            j++;
            if (parent.document.getElementById(cardInput).value.length > 0) {
                j = parent.document.getElementById(cardInput).value.length;
            }
            if (j >= (parseInt(length) + 1)) {
                cardNumber = parent.document.getElementById(cardInput).value;
                if (cardNumber.length > parseInt(length)) {
                    cardNumber = cardNumber.substring(0, parseInt(length));
                    parent.document.getElementById(cardInput).value = cardNumber;
                    parent.readCardType = "1";
                    if (flagLimt == true) {
                        if (length != cardNumber.length) {
                            parent.alert('');
                            parent.alert('卡号位数不正确,请重新刷卡!');
                            return false;
                        }
                    }
                }
            }

        }

        //删除特殊符号
        function DelSpecialCharFromCardNo(CardNo, isDelSpecialCharFromCardNo) {
            if (isDelSpecialCharFromCardNo == "1") {
                CardNo = CardNo.replace(/[^0-9]+/g, '');
            }
            return CardNo;
        }


        //用子页面文本框替换掉父页面的文本框
        //<param name='x'>x坐标</parame>
        //<param name='y'>y坐标</parame>
        //<param name='w'>宽度</parame>
        //<param name='h'>高度</parame>
        //<param name='cardInput'>输入框id</parame>
        //<param name='window'>window对象</parame>
        //<param name='cardType'>读卡类型</parame>
        //<param name='length'>卡长度</parame>
        //<param name='fill'>补齐标志</parame>
        //<param name='prefill'>补齐前缀</parame>
        //<param name='isLimt'>是否限制卡长度</parame>
        function SetCardReplaceShow(x, y, w, h, cardInput, window, cardType, length, fill, prefill, isLimt, css, tLength, IsOpenControl, TimeLimit, isDelSpecialCharFromCardNo) {
            cardLength = length;
            CardTypeReplace = cardType;
            flagLimt = isLimt;
            totalLength = tLength;
            InputTimeLimit = TimeLimit;
            isDelSpecialChar = isDelSpecialCharFromCardNo;
            IsOpenControlInput = IsOpenControl;
            var text = document.getElementById("txtOver");
            text.style.width = w;
            //子文本框 继承 父文本框 样式
            $("#txtOver").addClass(css);
            var inputid = parent.document.getElementById(cardInput);
            inputid.style.width = "0";
            inputid.style.height = "0";
            inputid.style.border = "0";
            inputid.hidden = "hidden";
            inputid.parentNode.insertBefore(text, inputid.nextSibling);
            //inputid.parentNode.replaceChild(text, inputid.nextSibling);
            try {
                inputid.nextSibling.focus();
            }
            catch (e) {
            }
            text.value = inputid.value;
            if (inputid.value != "") {
                text.readOnly = true;
            }
        }


        //回车事件
        function keyDown(obj) {
            if (parent.window.event.keyCode == 13) {
                //不加密
                var cardNo = obj.value;
                if (CardTypeReplace == "CodeCard") {

                    if (cardNo.length >= parseInt(cardLength)) {
                        cardNo = cardNo.substring(0, parseInt(cardLength));
                        // obj.value = cardNo;
                    }
                    else {
                        if (flagLimt == true) {
                            if (cardNo != "") {
                                if (cardNo.length > parseInt(cardLength)) {
                                    alert('卡号位数不正确，请重新刷卡！');
                                    return false;
                                }
                            }
                        }
                    }

                    if (cardNo != "") {
                        parent.readCardType = "1";
                        parent.ReadCardNoToInput(cardNo, true, obj.value);

                    }
                }

                //卡加密
                else {
                    Decrypt(cardNo);

                }
            }
        }


        //加密算法
        function Decrypt(encryptCardNo) {


            var index = cardLength;
            //判断卡号长度
            if (index < 0) {
                return;
            }
            //判断卡号长度
            if (encryptCardNo.Length < index) {
                return;
            }
            // 获取用户可见卡号
            var cardNo = encryptCardNo.substring(0, index);
            var tempStr = Encrypt(cardNo);   // 加密卡号

            if (tempStr == encryptCardNo) //判断 卡号加密后与密文数据是否一致
            {
                return cardNo;
            }
            else {
                return "";
            }
        }


        //加密对比
        function Encrypt(CardNo) {
            var tempNo = "";
            var separator = "";
            var constant = "MassunSoft_No.1";
            var _cardIdentify = "";
            var _cardNoEncryptLength = 30;
            CardNo = trimStr(CardNo); // 去掉空格

            if (CardNo == "") {
                alert("卡号不能为空！");
            }

            CardNo = CardNo.PadLeft(cardLength, '0');

            var tempStr = "" + CardNo + "" + CardNo + constant;//加密前的密文

            tempStr = hex_md5(tempStr);    // MD5加密


            for (var i = 0; i < tempStr.length; i++) {

                tempNo += parseInt(tempStr.charAt(i).charCodeAt());
            }

            tempStr = trimStr(CardNo) + separator + tempNo;//生成读取的卡号信息

            var cardNoLen = _cardNoEncryptLength - _cardIdentify.length;     // 减去卡标识的长度

            tempStr = tempStr.substring(0, cardNoLen) + _cardIdentify;

            return tempStr;//返回指定长度的加密串

        }
        function trimStr(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }
        String.prototype.PadLeft = function (totalWidth, paddingChar) {
            if (paddingChar != null) {
                return this.PadHelper(totalWidth, paddingChar, false);
            } else {
                return this.PadHelper(totalWidth, ' ', false);
            }
        }

        String.prototype.PadHelper = function (totalWidth, paddingChar, isRightPadded) {

            if (this.length < totalWidth) {
                var paddingString = new String();
                for (i = 1; i <= (totalWidth - this.length); i++) {
                    paddingString += paddingChar;
                }

                if (isRightPadded) {
                    return (this + paddingString);
                } else {
                    return (paddingString + this);
                }
            } else {
                return this;
            }
        }


    </script>

</head>
<body>
<input type="text" id="txtOver" onfocus="javascript:this.select();" onkeydown="keyDown(this)"/>
</body>
</html>