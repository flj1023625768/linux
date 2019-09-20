#!/bin/bash
#定义收件人邮箱
mail_user=fenggw@edu-edu.com.cn

usage() {
        echo "Useage : $0"
        echo "eg. sh $0 eth0"
        exit 1
}
if [ $# -lt 1 ]
then
        usage
fi
eth=$1
timer=1
#设置带宽值(KByte/s)
dd=10000
in_old=$(cat /proc/net/dev | grep $eth | sed -e "s/\(.*\)\:\(.*\)/\2/g" | awk '{print $1 }')
out_old=$(cat /proc/net/dev | grep $eth | sed -e "s/\(.*\)\:\(.*\)/\2/g" | awk '{print $9 }')
while true
do
        sleep ${timer}
        in=$(cat /proc/net/dev | grep $eth | sed -e "s/\(.*\)\:\(.*\)/\2/g" | awk '{print $1 }')
        out=$(cat /proc/net/dev | grep $eth | sed -e "s/\(.*\)\:\(.*\)/\2/g" | awk '{print $9 }')
        dif_in=$(((in-in_old)/timer))
        dif_in=$((dif_in/1024))
        dif_out=$(((out-out_old)/timer))
        dif_out=$((dif_out/1024))
        ct=$(date +"%F %H:%M:%S")
       # echo "${ct} -- IN: ${dif_in} KByte/s     OUT: ${dif_out} KByte/s"
	v=$(printf "%d" $((dif_out*100/dd)))
       # echo $v
	if [ $v -gt 80 ]
        then
            echo "网络占用超过80%" | mutt -s "报警邮件"  $mail_user
        fi

        in_old=${in}
        out_old=${out}
done
exit 0
