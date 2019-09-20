#!/bin/bash
#监控磁盘IO使用率并告警

#定义收件人邮箱
mail_user=xxx@xxxx

if ! which iostat &>/dev/null
then
    yum install -y sysstat
fi

if ! which iotop &>/dev/null
then
    yum install -y iotop
fi
#创建日志目录
logdir=/data/iolog
if [ ! -d $logdir ]
then
   mkdir $logdir
fi

dt=`date +%F`
#以日期作为日志名字

#获取IO，取5次平均值
get_io()
{
    iostat -dx 1 5 > $logdir/iostat.log
    sum=0

    for ut in `grep "^$1" $logdir/iostat.log |awk '{print $NF}' |cut -d '.' -f 1`
    do
        sum=$[$sum+$ut]
    done
    echo $[$sum/5]
}

while true
do
    for d in `iostat -dx |egrep -v '^$|Linux|Device:|CPU\}' |awk '{print $1}'`
    do
#	echo $d
        io=`get_io $d`
#        echo $io
        if [ $io -gt 70 ]
        then
            date >> $logdir/$dt
            cat $logdir/iostat.log >> $logdir/$dt
            iotop -obn2 >> $logdir/$dt
            echo "###################" >> $logdir/$dt

            echo "磁盘IO使用率超过70%" | mutt -s "报警邮件"  $mail_user
        fi
    done
    sleep 10
done
