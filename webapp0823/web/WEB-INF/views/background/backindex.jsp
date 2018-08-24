<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/19
  Time: 下午1:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>后台首页</title>
    <meta charset="utf-8">
    <style>
        .longchart{
            width: 100%;
            height: 400px;
        }
        .shortchart{
            height: 200px;
        }
        .number-box{
            height: 80px;
            margin-left: 40px;
            border: 1px solid rgb(180, 180, 180);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        .number-box i{
            margin-top: 10px;
        }
        .number-box p{
            margin-top: 17px;
            float:right;
            font-size: 30px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div style="padding-top: 10%">
        <div class="row">
            <div id="usercount" class="col-sm-2 number-box">
                <i class="fa fa-users fa-4x"></i>
                <p>${usercount}</p>
            </div>
            <div id="jobing" class="col-sm-2 number-box">
                <i class="fa fa-circle-o-notch fa-spin fa-4x"></i>
                <p>${runningjob}</p>
            </div>
            <div id="jobcount" class="col-sm-2 number-box">
                <i class="fa fa-tasks fa-4x"></i>
                <p>${jobcount}</p>
            </div>
            <div id="ping" class="col-sm-2 number-box">
                <i class="fa fa-rss fa-4x"></i>
                <p id="pingvalue"><i class="fa fa-spinner fa-pulse"></i></p>
            </div>
        </div>

        <div class="row" style="margin-top: 20px">
            <!-- 用户、计算任务统计 -->
            <div class="col-md-7">
                <div class="longchart" id="jobuser-statistics"></div><br>
            </div>
            <!-- 服务器状态监测 -->
            <div class="col-md-5">
                <div id="cpu-statistics" class="shortchart"></div>
                <div id="network-statistics" class="shortchart"></div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div id="mem-statistics" class="shortchart"></div>
            </div>
            <div class="col-md-6">
                <div id="diskio-statistics" class="shortchart"></div>
            </div>
        </div>
    </div>
</body>
<script>
    // 基于准备好的dom，初始化echarts实例
    var userChart = echarts.init(document.getElementById('jobuser-statistics'),'light');
    var cpuChart = echarts.init(document.getElementById('cpu-statistics'),'light');
    var networkChart = echarts.init(document.getElementById('network-statistics'));
    var memChart = echarts.init(document.getElementById('mem-statistics'),'light');
    var diskChart = echarts.init(document.getElementById('diskio-statistics'));
    //用户统计
    var usercate = [];
    var userdata = [];
    //计算任务统计
    var jobdata = [];
    //CPU监测
    var cpu_time = [];
    var cpuratio = [0];
    //网络带宽监测
    var network_time = [];
    var networkusage = [0];
    //内存状态监测
    var mem_time = [];
    var memoryusage = [0];
    //磁盘io状态监测
    var disk_time = [];
    var diskiousage = [0];
    var timestep = 2*1000;

    $(function () {
        getStatisticsData();
        updatePing();
    });

    $('#usercount').hover(function () {
       $(this).tooltip({
           title:'用户数量',
           placement:'bottom'
       });
    });

    $('#jobing').hover(function () {
        $(this).tooltip({
            title:'正在进行的作业',
            placement:'bottom'
        });
    });

    $('#jobcount').hover(function () {
        $(this).tooltip({
            title:'作业数量',
            placement:'bottom'
        });
    });

    $('#ping').hover(function () {
        $(this).tooltip({
            title:'与计算服务器延迟',
            placement:'bottom'
        });
    });

    function setCPURatio(ratio){
        var now = new Date();
        now = [now.getHours(),now.getMinutes(),now.getSeconds()].join(':');
        cpu_time.push(now);
        cpuratio.push(ratio);
        if(cpuratio.length > 6){
            cpu_time.shift();
            cpuratio.shift();
        }
    }

    function setNetWorkUsage(usage) {
        var now = new Date();
        now = [now.getHours(),now.getMinutes(),now.getSeconds()].join(':');
        network_time.push(now);
        networkusage.push(usage);
        if(networkusage.length > 6){
            network_time.shift();
            networkusage.shift();
        }
    }

    function setMemoryUsage(usage) {
        var now = new Date();
        now = [now.getHours(),now.getMinutes(),now.getSeconds()].join(':');
        mem_time.push(now);
        memoryusage.push(usage);
        if(memoryusage.length > 6){
            mem_time.shift();
            memoryusage.shift();
        }
    }

    function setDiskIOUsage(iousage) {
        var now = new Date();
        now = [now.getHours(),now.getMinutes(),now.getSeconds()].join(':');
        disk_time.push(now);
        diskiousage.push(iousage);
        if(diskiousage.length > 6){
            disk_time.shift();
            diskiousage.shift();
        }
    }

    // 指定图表的配置项和数据
    var useroption = {
        title: {
            text: '用户/计算任务统计'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'cross',
                crossStyle: {
                    color: '#999'
                }
            }
        },
        toolbox: {
            feature: {
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        legend: {
            data:['用户注册数量','计算任务数量']
        },
        xAxis: [
            {
                type: 'category',
                data: usercate,
                axisPointer: {
                    type: 'shadow'
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                name: '用户',
                min: 0,
                interval: 50,
                axisLabel: {
                    formatter: '{value} 名'
                }
            },
            {
                type: 'value',
                name: '计算任务',
                min: 0,
                max:1000,
                interval: 100,
                axisLabel: {
                    formatter: '{value} 个'
                }
            }
        ],
        series: [
            {
                name: '用户注册数量',
                type: 'bar',
                data: userdata
            },
            {
                name: '计算任务数量',
                type: 'line',
                data: jobdata
            }
        ]
    };
    /**
     * 监视CPU的表格选项
     * @type {{title: {text: string}, xAxis: {type: string, boundaryGap: boolean, data: Array}, yAxis: {boundaryGap: *[], type: string}, series: *[]}}
     */
    var cpuoption = {
        title: {
            text: 'CPU使用量%'
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: cpu_time
        },
        yAxis: {
            boundaryGap: [0, '50%'],
            type: 'value',
            max:100,
            min:0,
            axisLabel: {
                formatter: '{value} %'
            }
        },
        series: [
            {
                name:'使用率',
                type:'line',
                smooth:true,
                symbol: 'none',
                stack: 'a',
                areaStyle: {
                    normal: {}
                },
                data: cpuratio
            }
        ]
    };

    //监视网络带宽表格
    var networkoption = {
        title: {
            text: '网络带宽使用量Mbps'
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: network_time
        },
        yAxis: {
            boundaryGap: [0, '50%'],
            type: 'value',
            min:0
        },
        series: [
            {
                name:'占用带宽',
                type:'line',
                smooth:true,
                symbol: 'none',
                stack: 'a',
                areaStyle: {
                    normal: {}
                },
                data: networkusage
            }
        ]
    };
    //监测内存用量表格
    var memoption = {
        title: {
            text: '内存使用量%'
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: mem_time
        },
        yAxis: {
            boundaryGap: [0, '50%'],
            type: 'value',
            max:100,
            min:0,
            axisLabel: {
                formatter: '{value} %'
            }
        },
        series: [
            {
                name:'使用率',
                type:'line',
                smooth:true,
                symbol: 'none',
                stack: 'a',
                areaStyle: {
                    normal: {}
                },
                data: memoryusage
            }
        ]
    };
    //监测磁盘用量表格
    var diskoption = {
        title: {
            text: '磁盘IO%'
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: disk_time
        },
        yAxis: {
            boundaryGap: [0, '50%'],
            type: 'value',
            max:100,
            min:0,
            axisLabel: {
                formatter: '{value} %'
            }
        },
        series: [
            {
                name:'使用率',
                type:'line',
                smooth:true,
                symbol: 'none',
                stack: 'a',
                areaStyle: {
                    normal: {}
                },
                data: diskiousage
            }
        ]
    };

    // 使用刚指定的配置项和数据显示图表。
    userChart.setOption(useroption);
    cpuChart.setOption(cpuoption);
    networkChart.setOption(networkoption);
    memChart.setOption(memoption);
    diskChart.setOption(diskoption);

    setInterval(updateServerInfo,timestep);
    //setInterval(updatePing,30*timestep);

    function updateServerInfo(){
        updateCPU();
        updateNetWork();
        updateMemory();
        updateDisk();
    }

    /**
     * 异步更新CPU表格
     */
    function updateCPU() {
        $.ajax({
            url:'/admin/cpuratio',
            success:function (data) {
                //console.log('ratio='+data);
                setCPURatio(parseInt(data));
            },
            error:function () {
                setCPURatio(0);
            }
        });
        cpuChart.setOption({
            xAxis: {
                data: cpu_time
            },
            series: [{
                name:'使用率',
                data: cpuratio
            }]
        });
    }

    /**
     * 异步更新网络带宽表格
     */
    function updateNetWork() {
        $.ajax({
            url:'/admin/networkusage',
            success:function (data) {
                //console.log('usage='+data);
                setNetWorkUsage(parseFloat(data));
            },
            error:function (data) {
                //console.log("err:"+data);
                setNetWorkUsage(0);
            }
        });
        networkChart.setOption({
            xAxis: {
                data: network_time
            },
            series: [{
                name:'占用带宽',
                data: networkusage
            }]
        });
    }

    /**
     * 异步更新内存用量
     */
    function updateMemory() {
        $.ajax({
            url:'/admin/memoryusage',
            success:function (data) {
                //console.log('mem='+data);
                setMemoryUsage(parseInt(data));
            },
            error:function () {
                setMemoryUsage(0);
            }
        });
        memChart.setOption({
            xAxis: {
                data: mem_time
            },
            series: [{
                name:'使用率',
                data: memoryusage
            }]
        });
    }

    /**
     * 异步更新磁盘用量
     */
    function updateDisk() {
        $.ajax({
            url:'/admin/diskiousage',
            success:function (data) {
                console.log('disk='+data);
                setDiskIOUsage(parseInt(data));
            },
            error:function () {
                setDiskIOUsage(0);
            }
        });
        diskChart.setOption({
            xAxis: {
                data: disk_time
            },
            series: [{
                name:'使用率',
                data: diskiousage
            }]
        });
    }

    function updatePing() {
        $.ajax({
            url:'/admin/hpcping',
            success:function (data) {
                $('#pingvalue').text(data);
            }
        });
    }

    function getStatisticsData(){
        $.ajax({
            url:'/admin/userstatistics',
            success:function (data) {
                var charts = JSON.parse(data);
                for(var i in charts){
                    usercate.push(charts[i].categories);
                    userdata.push(charts[i].ydata);
                }
                userChart.setOption({
                    xAxis: [{
                            data: usercate,
                        }],
                    series: [{
                        // 根据名字对应到相应的系列
                        name: '用户注册数量',
                        data: userdata
                    }]
                });
            },
            error:function () {
                alert('获取用户统计数据失败');
            }
        });
        $.ajax({
            url:'/admin/jobstatistics',
            success:function (data) {
                var charts = JSON.parse(data);
                for(var i in charts){
                    jobdata.push(charts[i].ydata);
                }
                userChart.setOption({
                    series: [{
                        // 根据名字对应到相应的系列
                        name: '计算任务数量',
                        data: jobdata
                    }]
                });
            },
            error:function () {
                alert('获取计算任务统计数据失败');
            }
        });
    }
</script>
</html>
