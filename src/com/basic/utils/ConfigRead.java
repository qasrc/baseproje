package com.basic.utils;

import org.apache.commons.lang.StringUtils;

import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;


/**
 * 读取配置文件
 */
public class ConfigRead {

	static String configfile = "config/spring/jdbc.properties";
	public static Map<String,Properties> PropertiesSet = new HashMap<String,Properties>();

	static {
		getValue(configfile,"test");
	}

	public static String getValue(String configfile, String key) {
		String value = null;
		if (!StringUtils.isBlank(configfile)) {
			if(PropertiesSet.containsKey(configfile)){
				return PropertiesSet.get(configfile).getProperty(key,null);
			}
			InputStream inputStream = ConfigRead.class.getClassLoader().getResourceAsStream(configfile);
			Properties p = new Properties();
			PropertiesSet.put(configfile, p);
			try {
				p.load(inputStream);
				value = p.getProperty(key, null);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return value;
	}

    /**
     * 指定的编码方式来读取文件
     *
     * @param configfile 配置文件路径
     * @param key        属性名
     * @param encoding   编码方式，默认为utf-8
     * @return 属性值
     */
    public static String getValueByEncoding(String configfile, String key, String encoding) {
        if (encoding == null) {
            encoding = "utf-8";
        }
        String value = null;
        if (!StringUtils.isBlank(configfile)) {
            if (PropertiesSet.containsKey(configfile)) {
                return PropertiesSet.get(configfile).getProperty(key, null);
            }
            InputStream inputStream = ConfigRead.class.getClassLoader().getResourceAsStream(configfile);
            Properties p = new Properties();
            PropertiesSet.put(configfile, p);
            try {
                p.load(new InputStreamReader(inputStream, encoding));
                value = p.getProperty(key, null);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return value;
    }

	public static String getValue_jdbc(String key) {
		return getValue(configfile,key);
	}
//
//	public static Properties getProperties(String configfile) {
//		if (!StringUtils.isEmpty(configfile)) {
//			InputStream inputStream = ConfigRead.class.getClassLoader().getResourceAsStream(configfile);
//			properties = new Properties();
//			try {
//				properties.load(inputStream);
//
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		}
//		return properties;
//	}

}
