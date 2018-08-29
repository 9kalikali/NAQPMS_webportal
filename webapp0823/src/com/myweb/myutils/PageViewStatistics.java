package com.myweb.myutils;

import com.google.common.util.concurrent.AtomicLongMap;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 用于计算访问量的类
 */
public class PageViewStatistics {
    private static PageViewStatistics pvStat = null;
    private static ScheduledExecutorService service = null;
    private static AtomicLongMap<String> pvCountMap = AtomicLongMap.create();
    private static ReentrantLock lock = new ReentrantLock();
    private static int MONITOR_INIT_DELAY_SECONDS = 3;
    private static int MONITOR_INTERVAL_SECONDS = 10;
    private static Map<String, Long> map2 = new HashMap<String, Long>();

    /**
     * 获取单实例对象
     * @return
     */
    public static PageViewStatistics newInstance(){
        if(pvStat == null){
            synchronized (PageViewStatistics.class){
                if(pvStat == null){
                    pvStat = new PageViewStatistics();
                }
            }
        }
        return pvStat;
    }

    /**
     * 构造函数
     */
    public PageViewStatistics(){
        creatExecutirService();
        startMonitor();
    }

    /**
     * 计数值+1
     * @param key
     * @return
     */
    public long increase(String key){
        long result = -1;
        while(true){
            if(!lock.isLocked()){
                result = pvCountMap.incrementAndGet(key);
                break;
            }else{
                try {
                    TimeUnit.MICROSECONDS.sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    private void creatExecutirService(){
        if(service == null){
            service = Executors.newScheduledThreadPool(1, new ThreadFactory() {
                @Override
                public Thread newThread(Runnable r) {
                    Thread thread = new Thread(r);
                    thread.setDaemon(true);//宿主线程
                    return thread;
                }
            });
        }
    }

    private void startMonitor(){
        service.scheduleWithFixedDelay(
                new StatMonitorRunner(),
                MONITOR_INIT_DELAY_SECONDS,
                MONITOR_INTERVAL_SECONDS,
                TimeUnit.SECONDS);
    }

    private Map<String, Long> popCounter(){
        Map<String, Long> newMap = new HashMap<String, Long>();
        lock.lock();
        try{
            for(Iterator<String> it = pvCountMap.asMap().keySet().iterator(); it.hasNext();){
                String key = it.next();
                newMap.put(key, pvCountMap.get(key));
            }
            pvCountMap.clear();
        }finally {
            lock.unlock();
        }
        return newMap;
    }

    class StatMonitorRunner implements Runnable{

        @Override
        public void run() {
            Map<String, Long> map = popCounter();
            //可以将计数值写到数据库中
            for(Iterator<String> it = map.keySet().iterator(); it.hasNext(); ){
                String key = it.next();
                if(map2.containsKey(key)){
                    map2.put(key, new Long(map2.get(key).longValue() + map.get(key).longValue()));
                }else{
                    map2.put(key, map.get(key));
                }
            }
            System.out.println(map2);
        }
    }
}
