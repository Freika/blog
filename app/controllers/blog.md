Многие начинающие (и опытные) разработчики на Rails со временем задаются целью перенести свой существующий блог на Rails или завести новый. На Rails. Простейшие сущности, такие как сами посты, авторизация и комментарии делаются в два счета, но то, что получается в итоге на блог пока еще не тянет. Полноценному блогу, как и многим сайтам и сервисам, помимо базового функционала требуется еще несколько составляющих. О них и пойдет речь.

Во-первых, это RSS-лента. Любой блог, новостной сайт или сервис, где есть раздел со статьями, должен предоставлять посетителю подписаться на RSS-фид, чтобы не пропускать очередную запись. Во-вторых, sitemap, или карта сайта. Полезная вещь, если вы хотите, чтобы ваш сайт был более дружелюбен к индексации поисковыми системами. Третий и последний пункт -- robots.txt, инструкция для поисковиков о том, что индексировать не стоит. Мало кому захочется, чтобы в поисковой выдаче Яндекса или Гугла оказалась страница, приглашающая войти в администраторскую часть сайта.

###Содержание

- [RSS](#rss)
- [Sitemap](#sitemap)
- [robots.txt](#robotstxt)

##RSS
Для вещания RSS-фида создадим отдельный контроллер: `rails g controller Home rss`. Как видно из команды, за отдачу постов блога отвечает экшен `Home#rss`. Наполним контроллер содержимым:

```ruby
class HomeController < ApplicationController
  layout false

  def rss
    @posts = Post.all.order(created_at: :desc)
  end
end
```

Поскольку нам не нужно, чтобы экшен имел вьюху, мы это дело отключаем строкой `layout false`. В экшене `Home#rss` создаем переменную экземпляра, которая будет содержать посты, отдаваемые в RSS.
Далее редактируем файл `config/routes.rb`, добавляя в него адрес созданного RSS-фида:

```ruby
  get 'home/rss', controller: 'home', action: 'rss', format: 'rss', as: :feed
```

Теперь необходимо описать файл, который будет формировать наш RSS. Для этого отправляемся в директорию `app/views/home/` и создаем в ней файл `rss.builder`:

```ruby
xml.instruct!
xml.rss version: '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do

  xml.channel do
    xml.title 'Название блога'
    xml.description 'Описание блога'
    xml.link root_url
    xml.language 'ru'
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: 'home/rss'

    for post in @posts
      xml.item do
        xml.title post.title
        xml.link post_url(post)
        xml.pubDate(post.created_at.rfc2822)
        xml.guid post_url(post)
        xml.description(h(post.content))
      end
    end

  end

end
```

Обратите внимание на содержимое блока `xml.item do` -- в нем вам необходимо будет изменить значения `post.title` и `post.content` на собственные, в зависимости от того, какие атрибуты вы создали для вашей модели публикаций.

Последний шаг этой задачи -- добавление ссылки на RSS-фид в раздел `<head>` файла `app/views/layouts/application.html.erb`. Это необходимо для того, чтобы браузеры пользователей автоматически могли распознать вашу RSS-ленту.

```ruby
<link href="<%= feed_url %>" rel="alternate" title="RSS feed" type="application/rss+xml">
```

Готово, теперь ваш RSS-фид доступен по адресу `localhost:3000/home/rss`.


##Sitemap
Для создания карты сайта будет использоваться гем [DynamicSitemaps](https://github.com/lassebunk/dynamic_sitemaps). Установка стандартная: добавляем `gem 'dynamic_sitemaps'` в `Gemfile` и устанавливаем его командой `bundle install`.
Команда `rails generate dynamic_sitemaps:install` создаст файл `config/sitemap.rb`. Настроим его под наш проект:

```ruby
host "example.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  url posts_url
  Post.all.each do |post|
    url post
  end
end

ping_with "http://#{host}/sitemap.xml"
```

Как видно из кода, гем позволяет не только создавать карту сайтов, но и уведомлять поисковики о появлении новых публикаций. Возможности гема этим не ограничиваются, поэтому рекомендую ознакомиться с документацией гема по ссылке, указанной в начале раздела [Sitemap](#sitemap).
Для непосредственной генерации самой карты сайта используем команду `rake sitemap:generate`. Это создаст файл `sitemap.xml` в директории `public/sitemaps/`. Теперь создадим в нашем контроллере `Home` экшен `sitemap` со следующим содержимым:

```ruby
def sitemap
  respond_to do |format|
    format.xml { render file: 'public/sitemaps/sitemap.xml' }
    format.html { redirect_to root_url }
  end
end
```

Закончим начатое, добавив адрес карты сайта в файл `config/routes.rb`:

```ruby
  get 'sitemap.xml' => 'home#sitemap'
```

Помните, что карта сайта в описанной конфигурации не генерируется сама по себе, используйте [whenever](http://mkdev.me/categories/dlya-samyh-malenkih/posts/vypolnenie-koda-po-raspisaniyu-s-whenever-i-cron) для ежедневного её обновления выполнением команды `rake sitemap:generate`.


##robots.txt
С файлом robots.txt все совсем просто: помещаем его по адресу `public/` и вписываем в него пути, которые мы хотим запретить к индексированию и адрес карты сайта:

```
User-agent: *
Disallow: /admin
Sitemap: http://example.com/sitemap.xml
```

На этом все, теперь блог стал более дружелюбен к пользователям и поисковикам.
