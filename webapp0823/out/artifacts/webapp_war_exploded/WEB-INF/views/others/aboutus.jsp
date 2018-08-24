<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/30
  Time: 下午3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>关于我们</title>
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

    </style>
</head>
<body data-spy="scroll" data-target="#myScrollspy">
    <div class="container-fluid" style="padding-top: 70px">
        <div class="row">
            <div class="col-md-3" style="left: 100px">
                <ul class="nav aboutus-tabs aboutus-stacked" data-spy="affix" data-offset-top="125">
                    <li class="active"><a href="#section-1">大气物理研究所</a></li>
                    <li><a href="#section-2">计算机网络信息中心</a></li>
                    <li><a href="#section-3">联系方式</a></li>
                </ul>
            </div>
            <div class="col-md-8">
                <h2 id="section-1">大气物理研究所</h2>
                <p>中国科学院大气物理研究所（The Institute of Atmospheric Physics， Chinese Academy of Sciences）的前身是1928年成立的原国立中央研究院气象
                    研究所。1950年1月，中国科学院将气象、地磁和地震等部分科研机构合并组建成立中国科学院地球物理研究所。 1966年1月，根据中国气象事业发展的需要，中国
                    科学院决定将气 象研究室从地球物理研究所分出，正式成立中国科学院大气物理研究所。大气所是中国现代史上第一个研究气象科学的最高学术机构，已发展成为
                    涵盖大气科学领域各分支学 科的大气科学综合研究机构。</p>
                <p>大气所主要研究大气中各种运动和物理化学过程的基本规律及其与周围环境的相互作用，特别是研究在青藏高原、热带太平洋和中国复杂陆面作用下东亚天气气候和环
                    境的变 化机理、预测理论及其探测方法，以建立“东亚气候系统”和“季风环境系统”理论体系及遥感观测体系，发展新的探测和试验手段，为天气、气候和环境的监
                    测、预测 和控制提供理论和方法。</p>
                <hr>
                <h2 id="section-2">计算机网络信息中心</h2>
                <p>中国科学院计算机网络信息中心（Computer Network Information Center），成立于1995年4月，是中国科学院下属的科研事业单位。主要从事中国科学
                    院信息化建设、运行与支撑服务，以及计算机网络技术、数据库技术和科学工程计算的研究与开发，并负责中国境内的域名注册和地址分配服务。</p>
                <hr>
                <h2 id="section-3">联系我们</h2>
                <p>
                    文章投稿邮箱：xxxxxx@xxxx.com<br>
                    问题邮箱：xxxxxx@xxxx.com
                </p>
            </div>
        </div>
    </div>
</body>
</html>
