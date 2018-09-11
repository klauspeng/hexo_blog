---
title: PHP日志
categories: php
---
# PHP日志
## PHP自带
### error_log
> bool error_log ( string $message [, int $message_type = 0 [, string $destination [, string $extra_headers ]]] )

把错误信息发送到 web 服务器的错误日志，或者到一个文件里。 

message_type: 
0.PHP日志
1.发送到destination设置的邮件地址
3.被发送到位置为destination的文件里
4.直接发送到SAPI的日志处理程序中

```php
// 如果无法连接到数据库，发送通知到服务器日志
if (!Ora_Logon($username, $password)) {
    error_log("Oracle database not available!", 0);
}
// 如果用尽了 FOO，通过邮件通知管理员
if (!($foo = allocate_new_foo())) {
    error_log("Big trouble, we're all out of FOOs!", 1,
               "operator@example.com");
}
// 调用 error_log() 的另一种方式:
error_log("You messed up!", 3, "/var/tmp/my-errors.log");  
```

### file_put_contents
刚好看到这个函数,这个函数也能写入文件啊,而且没必要YII那么复杂吧

比如：`file_put_contents($file, $content.PHP_EOL, FILE_APPEND | LOCK_EX);`  

还实现了文件锁，哈哈，正好在研究文件锁。  
自己写了个,不断优化吧……
```php
function logWrite($conteent, $level = 'DEBUG',$file = 'temp.txt')
{
    $time = date('Y-m-d H:i:s',time());
    $level = sprintf('%6s', $level);
    if (empty($conteent))
        return false;
    if (is_array($conteent))
        $conteent = json_encode($conteent,JSON_UNESCAPED_UNICODE);

    file_put_contents($file, $time.$level.' '.$conteent.PHP_EOL, FILE_APPEND | LOCK_EX);
    return true;
}
```
结果：
```
2017-06-01 09:43:49 DEBUG {"test":"我我我","test1":"我我我","test2":"我我我","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:43:49  INFO {"test":"我我我","test1":"我我我","test2":"我我我","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:43:49  WARN {"test":"我我我","test1":"我我我","test2":"我我我","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:43:49 ERROR {"test":"我我我","test1":"我我我","test2":"我我我","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:44:15 DEBUG {"test":"阿斯达萨达撒大所多撒多撒多撒大所多","test1":"娃娃二群无多无群","test2":"ADASD","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:44:15  INFO {"test":"阿斯达萨达撒大所多撒多撒多撒大所多","test1":"娃娃二群无多无群","test2":"ADASD","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:44:15  WARN {"test":"阿斯达萨达撒大所多撒多撒多撒大所多","test1":"娃娃二群无多无群","test2":"ADASD","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:44:15 ERROR {"test":"阿斯达萨达撒大所多撒多撒多撒大所多","test1":"娃娃二群无多无群","test2":"ADASD","test3":"阿斯达奥撒多撒多撒多撒大所多所大所大大所多撒大"}
2017-06-01 09:47:42 DEBUG 阿斯达萨达撒大所多撒多撒多撒大所多
2017-06-01 09:47:42  INFO 阿斯达萨达撒大所多撒多撒多撒大所多
2017-06-01 09:47:42  WARN 阿斯达萨达撒大所多撒多撒多撒大所多
2017-06-01 09:47:42 ERROR 阿斯达萨达撒大所多撒多撒多撒大所多
```

## Monolog
[Github传送门](https://github.com/Seldaek/monolog)

Monolog works with PHP 7.0 or above, use Monolog ^1.0 for PHP 5.3+ support.

1. 8个级别：debug, info, notice, warning, error, critical, alert, emergency
2. 支持firePHP,chromePHP调试,浏览器输出
3. 支持redis,socket,数据库,文件流等写入

```php
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use Monolog\Handler\ChromePHPHandler;
use Monolog\Formatter\LineFormatter;

// Create some handlers
$stream = new StreamHandler(__DIR__.'/my_app.log');

// 设置格式

// the default output format is "[%datetime%] %channel%.%level_name%: %message% %context% %extra%\n"
$output = "[%datetime%] > %level_name% > %message% %context% %extra%\n";
// finally, create a formatter
$formatter = new LineFormatter($output);
$stream->setFormatter($formatter);

// Create the main logger of the app
$logger = new Logger('my_logger');
$logger->pushHandler($stream);
$logger->pushHandler(new ChromePHPHandler());

$logger->error('12121');
$logger->warn('这是警告信息！');

// Or clone the first one to only change the channel
$securityLogger = $logger->withName('security');

$securityLogger->error('12121');
$securityLogger->warn('这是警告信息！');

```

## thinkphp5.0.9的Log
File驱动也是用的error_log函数
```php
protected function write($message, $destination, $apart = false)
{
    //检测日志文件大小，超过配置大小则备份日志文件重新生成
    if (is_file($destination) && floor($this->config['file_size']) <= filesize($destination)) {
        rename($destination, dirname($destination) . DS . time() . '-' . basename($destination));
        $this->writed[$destination] = false;
    }
    ......
    return error_log($message, 3, $destination);
}
```

## YII2.0.11的Log
File驱动：用的是fwrite和file_put_contents
```php
/**
 * Writes log messages to a file.
 * @throws InvalidConfigException if unable to open the log file for writing
 */
public function export()
{
    $text = implode("\n", array_map([$this, 'formatMessage'], $this->messages)) . "\n";
    if (($fp = @fopen($this->logFile, 'a')) === false) {
        throw new InvalidConfigException("Unable to append to log file: {$this->logFile}");
    }
    @flock($fp, LOCK_EX);
    if ($this->enableRotation) {
        // clear stat cache to ensure getting the real current file size and not a cached one
        // this may result in rotating twice when cached file size is used on subsequent calls
        clearstatcache();
    }
    if ($this->enableRotation && @filesize($this->logFile) > $this->maxFileSize * 1024) {
        $this->rotateFiles();
        @flock($fp, LOCK_UN);
        @fclose($fp);
        @file_put_contents($this->logFile, $text, FILE_APPEND | LOCK_EX);
    } else {
        @fwrite($fp, $text);
        @flock($fp, LOCK_UN);
        @fclose($fp);
    }
    if ($this->fileMode !== null) {
        @chmod($this->logFile, $this->fileMode);
    }
}
```

## laravel5.4
用的是Monolog