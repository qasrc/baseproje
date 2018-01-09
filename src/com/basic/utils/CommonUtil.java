package com.basic.utils;

import com.basic.shiro.ShiroUser;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * @author 张战
 *         Created on 2016/12/28  13:39
 */
public abstract class CommonUtil {

    public static final String configPath = "config/spring/config.properties";

    /**
     * 求商
     *
     * @param n1  被除数
     * @param n2  除数
     * @param num 要保留几位小数
     * @return 两个数ooo的商，四舍五入
     */
    public static Double getDivide1(Double n1, Double n2, int num) {
        BigDecimal a = new BigDecimal(n1.toString());
        BigDecimal b = new BigDecimal(n2.toString());
        return a.divide(b, num, BigDecimal.ROUND_HALF_UP).doubleValue();
    }


    /**
     * 获取距当前日期指定天数的日期
     *
     * @param days 如果为+，则当前日期加上指定的天数。如果为-，则当前日期减去指定的天数
     * @return 指定天数的日期，yyyy-MM-dd
     */
    public static String getTime(Integer days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_MONTH, days);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDateFormat.format(calendar.getTime());
    }

    /**
     * 根据index获取指定的年份
     *
     * @param index 距当前年份的年数
     * @return 如果index > 0,则当前年份加上指定的index
     * index < 0,则当前年份减去指定的index
     * index = 0,返回当前年份
     */
    public static String getYearByIndex(Integer index) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.YEAR, index);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy");
        return simpleDateFormat.format(calendar.getTime());
    }

    /**
     * 根据index，得到某一年的开始月份
     *
     * @param index
     * @return
     */
    public static String getYearStart(Integer index) {
        String year = CommonUtil.getYearByIndex(index);
        return year + "-01";
    }

    /**
     * 根据index，得到某一年的结束月份
     *
     * @param index
     * @return
     */
    public static String getYearEnd(Integer index) {
        String year = CommonUtil.getYearByIndex(index);
        return year + "-12";
    }

    /**
     * 根据模版和指定的日期获取日期的字符串表示
     */
    public static String getDateStringByPattern(String patter, Date date) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(patter);
        return simpleDateFormat.format(date);
    }


    /**
     * 获取当前登录主体的角色名字集合
     */
    public static List<String> getRoleListPrincipals() {
        Subject subject = SecurityUtils.getSubject();
        PrincipalCollection principalCollection = subject.getPrincipals();
        ShiroUser shiroUser = (ShiroUser) principalCollection.getPrimaryPrincipal();
        if (shiroUser != null) {
            return shiroUser.roleNameList;
        }
        return null;
    }


}
