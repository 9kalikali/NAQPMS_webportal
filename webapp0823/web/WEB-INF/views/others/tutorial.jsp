<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/5/2
  Time: 上午8:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>入门指南</title>
    <style>
        /* Custom Styles */
        ul.aboutus-tabs{
            width: 200px;
            margin-top: 20px;
            border-radius: 4px;
            border: 1px solid #ddd;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.067);
        }
        ul.aboutus-tabs li{
            margin: 0;
            border-top: 1px solid #ddd;
        }
        ul.aboutus-tabs li:first-child{
            border-top: none;
        }
        ul.aboutus-tabs li a{
            margin: 0;
            padding: 8px 16px;
            border-radius: 0;
        }
        ul.aboutus-tabs li.active a, ul.aboutus-tabs li.active a:hover{
            color: #fff;
            background: #0088cc;
            border: 1px solid #0088cc;
        }
        ul.aboutus-tabs li:first-child a{
            border-radius: 4px 4px 0 0;
        }
        ul.aboutus-tabs li:last-child a{
            border-radius: 0 0 4px 4px;
        }
        ul.aboutus-tabs.affix{
            top: 30px; /* Set the top position of pinned element */
        }
        .tutorial-img{
            width: 100%;
        }
        .table-head tr th{
            text-align: center;
        }
        .table-body tr td{
            text-align: center;
        }
        .tutorial-content p{
            font-size: 17px;
        }
    </style>
    <script>
        $(function () {
            $('#mynav').affix({
                offset:{
                    top:100
                }
            });
        });
    </script>
</head>
<body data-spy="scroll" data-target="#myScrollspy">
    <div class="container-fluid" style="padding-top:70px;padding-bottom: 50px">
        <div class="row">
            <div class="col-md-3" id="myScrollspy" style="left: 100px">
                <ul id="mynav" class="nav aboutus-tabs aboutus-stacked" data-spy="affix">
                    <li class="active"><a href="#section-1">NAQPMS</a></li>
                    <li><a href="#section-2">用户指南</a></li>
                    <li><a href="#section-3">数据共享</a></li>
                    <li><a href="#section-4">数据展示</a></li>
                    <li><a href="#section-5">计算任务</a></li>
                </ul>
            </div>
            <div class="col-md-8 tutorial-content">
                <h2 id="section-1">嵌套网格空气质量预报模式系统</h2>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;嵌套网格空气质量预报模式系统(NAQPMS)是中科院大气物理研究所自主研发的大气污染数值预报模式，它充分借鉴吸收了国际上先进的天气预报模式、空气污染数值预
                    报模式等的优点,并体现了中国各区域、城市的地理、地形环境、污染源的排放等特点。此系统在计算机技术上采用高性能并行集群的结构,低成本地 实现了大
                    容量高速度的计算,从而解决了预报时效问题;在研制过程中考虑了自然源对城市空气质量的影响,设计了东亚地区起沙机制的模型;并采用 城市空气质量自动监
                    测系统的实际监测资料进行计算结果的同化。该模式系统被广泛地运用于多尺度污染问题的研究,它不但可以研究区域尺度的空气污染问题(如沙尘输送、酸雨、
                    污染物的跨国输送等),还可以研究城市尺度的空气质量等问题的发生机理及其变化规律,以及不同尺度之间的相互影响过程。NAQPMS模式成功实现了在线的、全
                    耦合的包括多尺度多过程的数值模拟,模式可同时计算出多个区域的结果,在各个时步对各计算区域边界进行数据交换,从而实现模式多区域的双向嵌套。同时,模
                    式系统的并行计算和理化过程的模块化则有效地保证了NAQPMS模式的在线实时模拟。
                </p>
                <h2>区域大气污染模式框架结构</h2>
                <img class="tutorial-img" style="height: 800px" src="/images/image1.png"/>
                <img class="tutorial-img" style="height: 800px" src="/images/image2.png"/>
                <h2>模式的应用与贡献</h2>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自主研制的模式已在国家环境质量预报预警中心、京津冀、长三角和珠三角区域中心及全国大多数省市投入业务运行，并服务于北京奥运、上海世博会、广州亚运
                    会、南京青奥会、北京APEC峰会、9.3阅兵、G20等重大国际活动。成果并广泛应用于国家和京津冀、长三角、珠三角等重点区域大气污染防治工作，成为多项重
                    大政策和技术文件和40多个业务平台的核心科技支撑。自主研制的预报模式系统NAQPMS，列入2014年3月科技部和环保部联合发布的《大气污染防治先进技术汇
                    编》，被国家环保部门广泛认可和采用，有力支撑了国家重污染天气预报预警体系建设和污染控制方案制定。被环保部列为《大气颗粒物来源解析技术指南》的推
                    荐模式方法，此为唯一被推荐的国产模式。被中国环境监测总站列入《环境空气质量预报预警方法技术指南》，指导全国业务部门空气质量预报。
                </p>
                <img class="tutorial-img" style="height: 450px" src="/images/image4.png"/>
                <hr>
                <h2 id="section-2">用户指南</h2>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本节对平台的界面和用户基本操作进行简单的介绍</p>
                <h3>用户登陆与注册</h3>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本平台的一部分功能需要注册账号才能使用，所以没有账号的用户请点击页面右上角的注册进行账号注册，点击登陆进入登陆页面进行登陆。</p>
                <img src="/images/login_regist.png"/>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;登陆后右上角显示了用户 的账号和未读通知。用户可以点击登出退出登录。</p>
                <img src="/images/logined.png"/>
                <h3>用户组</h3>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;用户组，由于平台提供的数据并不是全部都是公开数据，一部分数据需要用户拥有一定的下载资格才可以获取。所以每个用户都有一个自己所属的用户组，用户组与下载权
                限的对应关心如下表所示。如果用户希望提升自己的用户组，请通过电子邮件联系管理人员，按要求提供相应的审核材料。审核通过后便可以提升用户组。
                <table class="table table-bordered">
                    <caption style="text-align: center">用户组-下载权限对应关系</caption>
                    <thead class="table-head">
                    <tr>
                        <th>用户组</th>
                        <th>公开数据</th>
                        <th>研究所内共享</th>
                        <th>课题组内共享</th>
                    </tr>
                    </thead>
                    <tbody class="table-body">
                    <tr>
                        <td>普通用户</td>
                        <td>可以</td>
                        <td>不可以</td>
                        <td>不可以</td>
                    </tr>
                    <tr>
                        <td>中级用户</td>
                        <td>可以</td>
                        <td>可以</td>
                        <td>不可以</td>
                    </tr>
                    <tr>
                        <td>高级用户</td>
                        <td>可以</td>
                        <td>可以</td>
                        <td>可以</td>
                    </tr>
                    </tbody>
                </table>
                <h3>用户中心</h3>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;用户可以点击首页右上角的用户中心按钮进入用户中心，用户可以在此更改密码以及自已的基本信息。除此之外，使用了计算任务服务的用户可以在用户中心查看自己提交
                    过的计算任务的状态和结果。消息中心则显示了系统或管理员对用户进行的通知。</p>
                <img src="/images/usercenter.png" style="width: 100%;height: 500px"/>
                <hr>
                <h2 id="section-3">数据共享</h2>
                <p>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;进入此页面需要用户登陆，请有需要的用户前往注册页面注册账号后再来浏览此页面。数据共享页面提供了模式数据集的下载供学生和研究人
                    员进行学习研究。使用者通过侧边栏的导航找到合适的数据集，点击后会显示数据集的详细信息，按需下载数据。需要注意的是不同的用户组所能够下载的数据是不同
                    的，如果当前您所在的用户组不符合要求，请返回上文产看用户组的说明。
                </p>
                <hr>
                <h2 id="section-4">数据展示</h2>
                <p>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数据展示页面分为两个部分，第一个部分在线展示是将模式绘制的图片展示出来，用户可以通过选择不同的参数查看不同的结果。第二个部分webgis综合展示是顺应时
                    代潮流以浏览器即时渲染的形式对污染源数据进行可视化展示，页面采用HTML5的canvas元素以及JavaScript编制了一个风场模拟动画，又利用高德地图API提供的热
                    力图接口展示当前时间不同污染源的分布状态。
                </p>
                <img src="/images/datadisplay.png" style="width: 100%;height: 500px"/>
                <img src="/images/webgis.png" style="width: 100%;height: 500px"/>
                <hr>
                <h2 id="section-5">计算任务</h2>
                <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;希望通过平台提交计算任务的用户需要账号登陆，如果没有账号请通过右上角的注册链接注册账号后浏览该页面。计算任务页面为希望利用模式进行计算的用户提供的公
                    共接口，使用者有两种方式提交计算任务，如果用户是气象模式的有经验使用者，那么可以自行编制脚本并选择提交脚本进行计算任务提交。如果用户之前没有使用过
                    类似的气象模式，则选择后项，利用右侧的框选工具框选希望计算的区域或者直接在输入框中输入经纬度确定区域，之后填入相应的参数，服务器会为用户自动生成脚
                    本提交至计算服务器。计算任务的状态和结果可以在用户中心浏览，有关用户中心的说明请返回上文用户中心进行查阅。</p>
                <p>进入计算任务界面后，左侧可以看到提供的两种脚本提交方式</p>
                <img src="/images/job1.png" style="width: 50%"/>
                <p>选择提交脚本选项可从本地上传脚本</p>
                <img src="/images/job2.png" style="width: 50%"/>
                <p>选择提交参数选项进入框选区域模式，点击右侧的框选工具在希望计算的区域进行框选</p>
                <img src="/images/job3.png" style="width: 30%"/><img src="/images/job4.png" style="width: 30%;height: 276px;"/>
                <p>框选成功后在参数区域填入相关参数，点击提交即可成功提交计算任务</p>
                <img src="/images/job5.png" style="width: 30%;height: 274px"/><img src="/images/job6.png" style="width: 30%"/>
            </div>
        </div>
    </div>
</body>
</html>
