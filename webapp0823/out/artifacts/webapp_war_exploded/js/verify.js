;(function($, window, document,undefined) {

    //定义Code的构造函数
    var Code = function (ele, opt) {
        this.$element = ele,
            this.defaults = {
                type: 1,
                figure: 100,   //位数，仅在type=2时生效
                arith: 0,  //算法，支持加减乘，0为随机，仅在type=2时生效
                width: '100px',
                height: '40px',
                fontSize: '20px',
                codeLength: 4,
                btnId: 'btn-lgin',
                ready: function () {
                },
                success: function () {
                },
                error: function () {
                }
            },
            this.options = $.extend({}, this.defaults, opt)
    };
    var _code_chars = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    var _code_color1 = ['#fffff0', '#f0ffff', '#f0fff0', '#fff0f0'];
    var _code_color2 = ['#FF0033', '#006699', '#993366', '#FF9900', '#66CC66', '#FF33CC'];

    //定义Code的方法
    Code.prototype = {
        init: function () {
            var _this = this;
            this.loadDom();
            this.setCode();
            this.options.ready();
            this.$element[0].onselectstart = document.body.ondrag = function () {
                return false;
            };
            //点击验证码
            this.$element.find('.verify-code, .verify-change-code').on('click', function () {
                _this.setCode();
            });
            //确定的点击事件
            this.htmlDoms.code_btn.on('click', function () {
                //alert("oneClick!");
                _this.checkCode();
            });
        },

        //加载页面
        loadDom: function () {
            var panelHtml = '<div class="certify-code-panel">\
                <div class="verify-code"></div>\
                <div class="verify-code-area">\
                    <div class="verify-input-area">\
                        <input type="text" class="form-control" placeholder="验证码"/>\
                    </div>\
                    <div class="verify-change-area">\
                        <a class="verify-change-code">换一张</a>\
                    </div>\
                </div>\
            </div>';
            this.$element.append(panelHtml);

            this.htmlDoms = {
                code_btn: $('#' + this.options.btnId),
                code: this.$element.find('.verify-code'),
                code_area: this.$element.find('.verify-code-area'),
                code_input: this.$element.find('.form-control'),
            };

            this.htmlDoms.code.css({
                'width': this.options.width,
                'height': this.options.height,
                'line-height': this.options.height,
                'font-size': this.options.fontSize
            });
            this.htmlDoms.code_area.css({'width': this.options.width});
        },

        //设置验证码
        setCode: function () {
            var color1Num = Math.floor(Math.random() * 3);
            var color2Num = Math.floor(Math.random() * 5);

            this.htmlDoms.code.css({'background-color': _code_color1[color1Num], 'color': _code_color2[color2Num]});
            this.htmlDoms.code_input.val('');

            var code = '';
            this.code_chose = '';

            if (this.options.type == 1) {    //普通验证码
                for (var i = 0; i < this.options.codeLength; i++) {
                    var charNum = Math.floor(Math.random() * 52);
                    var tmpStyle = (charNum % 2 == 0) ? "font-style:italic;margin-right: 10px;" : "font-weight:bolder;";
                    tmpStyle += (Math.floor(Math.random() * 2) == 1) ? "font-weight:bolder;" : "";
                    this.code_chose += _code_chars[charNum];
                    code += '<font style="' + tmpStyle + '">' + _code_chars[charNum] + '</font>';
                }
            }
            this.htmlDoms.code.html(code);

        },

        //比对验证码
        checkCode: function () {
            if (this.options.type == 1) {        //普通验证码
                var own_input = this.htmlDoms.code_input.val().toUpperCase();
                this.code_chose = this.code_chose.toUpperCase();
            }

            if (own_input == this.code_chose) {
                this.options.success();
            } else {
                this.options.error();
                this.setCode();
            }
        }
    };

    //在插件中使用codeVerify对象
    $.fn.codeVerify = function(options, callbacks) {
        var code = new Code(this, options);
        code.init();
    };

})(jQuery, window, document);