<%--
  Created by IntelliJ IDEA.
  User: 97007
  Date: 2021/5/28
  Time: 22:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";

%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>>">
    <script src="jquery/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>

    <script>

        function getCharts(){
            $.ajax({
                url:"workbench/transaction/getTranStageCounts.do",
                dataType:"json",// {["stage":"","nums":""],[]}
                success:function(data){
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    let legend = []
                    let stageData= []
                    let lenght = data.length
                    console.log(legend)
                    console.log(stageData)
                    $.each(data,function (index,value){
                        legend.push(value.stage)
                        stageData.push({value:value.nums,name:value.stage})
                    })
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '漏斗图',
                            subtext: '交易阶段'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}%"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        legend: {
                            data: legend
                        },

                        series: [
                            {
                                name:'漏斗图',
                                type:'funnel',
                                left: '10%',
                                top: 60,
                                //x2: 80,
                                bottom: 60,
                                width: '80%',
                                // height: {totalHeight} - y - y2,
                                min: 0,
                                max: length,
                                minSize: '0%',
                                maxSize: '100%',
                                sort: 'descending',
                                gap: 2,
                                label: {
                                    show: true,
                                    position: 'inside'
                                },
                                labelLine: {
                                    length: 10,
                                    lineStyle: {
                                        width: 1,
                                        type: 'solid'
                                    }
                                },
                                itemStyle: {
                                    borderColor: '#fff',
                                    borderWidth: 1
                                },
                                emphasis: {
                                    label: {
                                        fontSize: 20
                                    }
                                },
                                data: stageData
                            }
                        ]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })
        }
        $(function(){
            getCharts()
        })
    </script>
</head>
<body>
    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 600px;height:400px;"></div>
    <script type="text/javascript">

    </script>
</body>
</html>
