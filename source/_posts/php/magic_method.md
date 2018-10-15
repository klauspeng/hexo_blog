---
title: php魔术方法及魔法常量
date: 2018/10/9
categories: php
---

php魔术方法及魔法常量的理解及使用
<!-- more -->


## `__get` `__set` `__isset` `__unset`
1. 从一个难以访问的属性读取数据的时候 __get() 方法被调用
2. 向一个难以访问的属性赋值的时候 __set() 方法被调用
3. 难以访问包括：（1）私有属性，（2）没有初始化的属性

```php
protected $config = array(
    'maxSize'    => -1,    // 上传文件的最大值
    'allowExts'  => array(),    // 允许上传的文件后缀 留空不作后缀检查
    'allowTypes' => array(),    // 允许上传的文件类型 留空不做检查
    'savePath'   => '',// 上传文件保存路径
    'saveRule'   => 'uniqid',// 上传文件命名规则
    'hashType'   => 'md5_file',// 上传文件Hash规则函数名
);

public function __get($name)
{
    if (isset($this->config[$name])) {
        return $this->config[$name];
    }
    return null;
}

public function __set($name, $value)
{
    if (isset($this->config[$name])) {
        $this->config[$name] = $value;
    }
}

public function __isset($name)
{
    return isset($this->config[$name]);
}
```

## `__construct` `__destruct`
`__construct` 类的构造函数--初始化

`__destruct()`，类的析构函数--销毁一个类之前执行

```php
class Person{   
                            
  public $name;     
  public $age;     
  public $sex;     
                                  
  public function __construct($name="", $sex="男", $age=22)
  {  
    $this->name = $name;
    $this->sex = $sex;
    $this->age = $age;
  }
  
  /**
   * say 说话方法
   */
  public function say()
  { 
    echo "我叫：".$this->name."，性别：".$this->sex."，年龄：".$this->age;
  }  
  
  /**
   * 声明一个析构方法
   */
  public function __destruct()
  {
      echo "我觉得我还可以再抢救一下，我的名字叫".$this->name;
  }
}

$Person = new Person("小明");
unset($Person); //销毁上面创建的对象$Person
```

## `__call` `__callStatic`
在对象中调用一个不可访问方法时，`__call()` 会被调用。

在静态上下文中调用一个不可访问方法时，`__callStatic()` 会被调用。
```php
class MethodTest 
{
    public function __call($name, $arguments) 
    {
        // 注意: $name 的值区分大小写
        echo "Calling object method '$name' "
             . implode(', ', $arguments). "\n";
    }

    /**  PHP 5.3.0之后版本  */
    public static function __callStatic($name, $arguments) 
    {
        // 注意: $name 的值区分大小写
        echo "Calling static method '$name' "
             . implode(', ', $arguments). "\n";
    }
}

$obj = new MethodTest;
$obj->runTest('in object context'); # Calling object method 'runTest' in object context

MethodTest::runTest('in static context');  # Calling static method 'runTest' in static context
```

## ` __toString` ` __clone` `__debugInfo`
` __toString` 类被当成字符串时的回应方法

` __clone` 当对象复制完成时调用

`__debugInfo` 打印所需调试信息,该方法在PHP 5.6.0及其以上版本才可以用

```php
class Person
{
    public $sex;
    public $name;
    public $age;

    public function __construct($name = "", $age = 25, $sex = '男')
    {
        $this->name = $name;
        $this->age  = $age;
        $this->sex  = $sex;
    }

    public function __toString()
    {
        return '姓名：' . $this->name . ',性别：' . $this->sex . ',年龄：' . $this->age . PHP_EOL;
    }

    public function __clone()
    {
        echo __METHOD__ . '你正在克隆对象', PHP_EOL;
    }

    public function __debugInfo()
    {
        return [
            'name' => $this->name,
            'sex'  => $this->sex,
            'age'  => $this->age,
        ];
    }

}

$zhang = new Person('张三');
echo $zhang; # 姓名：张三,性别：男,年龄：25

$lisi = clone $zhang; # Person::__clone你正在克隆对象

var_dump($lisi);
/*object(Person)#2 (3) {
    ["name"]=>
      string(6) "张三"
    ["sex"]=>
      string(3) "男"
    ["age"]=>
      int(25)
}*/

```
## `__autoload` 
`__autoload` 尝试加载未定义的类,spl_autoload_register已实现

```php
/** 
 * 文件autoload_demo.php 
 */ 
function __autoload($className) { 
  $filePath = “project/class/{$className}.php”; 
  if (is_readable($filePath)) { 
    require($filePath); 
  } 
}
```

## `__sleep`  `__wakeup`
`__sleep` 执行serialize()时，先会调用这个函数

`__wakeup` 执行unserialize()时，先会调用这个函数

```php
class Person
{
    public $sex;
    public $name;
    public $age;

    public function __construct($name="", $age=25, $sex='男')
    {
        $this->name = $name;
        $this->age = $age;
        $this->sex = $sex;
    }

    /**
     * @return array
     */
    public function __sleep() {
        echo "当在类外部使用serialize()时会调用这里的__sleep()方法",PHP_EOL;
        $this->name = base64_encode($this->name);
        return array('name', 'age'); // 这里必须返回一个数值，里边的元素表示返回的属性名称
    }

    /**
     * __wakeup
     */
    public function __wakeup() {
        echo "当在类外部使用unserialize()时会调用这里的__wakeup()方法",PHP_EOL;
        $this->name = 2;
        $this->sex = '男';
        // 这里不需要返回数组
    }
}

$person = new Person('小明'); // 初始赋值
var_dump(serialize($person));
var_dump(unserialize(serialize($person)));
```

## 魔术常量
```php
<?php
/**
 * Created by crontabMonitor.
 * User: Liupeng
 * Date: 2018-10-10 16:05
 */

namespace Hi;

echo __LINE__, PHP_EOL; # 10

echo __FILE__, PHP_EOL; # /mnt/hgfs/workspace/crontabMonitor/Person.php

echo __DIR__, PHP_EOL; # /mnt/hgfs/workspace/crontabMonitor

function say()
{
    echo __FUNCTION__, PHP_EOL; # Hi\TraitTest
}

trait TraitTest
{
    public static function getTrait()
    {
        echo __TRAIT__, PHP_EOL;
    }
}

TraitTest::getTrait(); # Hi\TraitTest

class ConstantsPredefined
{
    /**
     * 获取类名称
     */
    public function getClass()
    {
        echo __CLASS__, PHP_EOL; # Hi\ConstantsPredefined
    }

    /**
     * 方法名
     */
    public function getMethod()
    {
        echo __FUNCTION__, PHP_EOL; # getMethod
        echo __METHOD__, PHP_EOL; # Hi\ConstantsPredefined::getMethod
    }

    /**
     * 获取命名空间
     */
    public function getNameSpace()
    {
        echo __NAMESPACE__, PHP_EOL; # Hi
    }

}

$constantsPredefined = new \Hi\ConstantsPredefined();
$constantsPredefined->getClass();
$constantsPredefined->getMethod();
$constantsPredefined->getNameSpace();
```

记忆`dir/file/line/namesapace/class/method/trait/function`