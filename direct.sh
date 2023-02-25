useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
expi="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null


useradd -e -d -s /bin/false -M pranto1

useradd -m -e $(date -d "3 days" +"%Y-%m-%d") -s /bin/false pranto1 && echo pranto1:123123 | chpasswd
useradd -m -e $(date -d "3 days" +"%Y-%m-%d") -s /bin/false pranto1 && echo pranto1:123123 | chpasswd






