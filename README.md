# AlertQueue
按照想要的顺序弹框

在启动阶段，多个异步接口调用，回掉时间无法控制，通过调度组的方式拿到方法的回调，然后根据需求控制需要优先present哪个alert
