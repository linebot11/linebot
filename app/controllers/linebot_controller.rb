class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback

    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|

      ran = rand(5)
      
      # event.message['text']でLINEで送られてきた文書を取得
      if event.message['text'].include?("好き")
        case ran
        when 1
          response = "んはぁぁぁ！すきすきすきすきすきすきすきすき"
        when 2
          response = "好き好き大好き大好きだよすきすきすきすき"
        when 3
          response = "好き？ねぇ好きって言った？私のこと愛してるっていった？うれしい・・・"
        else
          response = "大好きだよ。いつでも君を見てるからね。うふふ"
        end
      elsif event.message["text"].include?("愛")
        case ran
        when 1
          response = "んほぉぉぉ！すきだよすきすきすきすき愛してる愛してる愛してる"
        when 2
          response = "好き好き大好き大好きだよすきすき愛してるすきすきすきすき"
        when 3
          response = "好き？ねぇ好きって言った？私のこと愛してるっていった？うれしい・・・"
        else
          response = "愛してる？今、愛してるって言ってくれたの？嬉しい嬉しい嬉しい。私もずっと愛してるからね"
        end
      elsif event.message["text"].include?("行ってきます")
        case ran
        when 1
          response = "どこにいくつもりなのかな？きみはずっと私と一緒にいるんだよ？"
        when 2
          response = "行かないで行かないで行かないで行かないで行かないで行かないで"
        when 3
          response = "待ってるからね。ずっとずっとずっとずっとずっとずっとまってるから"
        else
          response = "どこいくの？ねぇどこいくの？どこいくの？ねぇねぇねぇ寂しい寂しい寂しい"
        end
      elsif event.message["text"].include?("ただいま")
        case ran
        when 1
          response = "他の女の匂いがする。洗い流さないと汚れちゃう汚れちゃう汚れちゃう綺麗にしなくちゃ"
        when 2
          response = "ねぇ、外で誰と会ってたの？ねぇねぇねぇねぇねぇ"
        when 3
          response = "おかえり。ちゃんと帰ってきてくれたんだね。良かった。でももう心配かけちゃだめだよ。もう逃がさないから"
        else
          response = "おかえりなさい。ずーっとここでまってたんだよ。もう待たせないでね。"
        end
      elsif event.message['text'].include?("おはよう")
        case ran
        when 1
          response = "おはよう。可愛い寝顔だったね"
        when 2
          response = "ねぇ、寝言で言ってた名前だれなのかな？ねぇ、ねぇねぇねぇねぇねぇねぇねぇねぇ"
        when 3
          response = "おはようございます。うふふ、今日もずっと一緒だね"
        else
          response = "おはよう。なんで今まで連絡くれなかったの？ねぇどうして？"
        end
      elsif event.message['text'].include?("おやすみ")
        case ran
        when 1
          response = "おやすみなさい。続きは夢の中で・・・ね"
        when 2
          response = "おやすみ。電気消しておくね"
        when 3
          response = "また明日ね。おやすみなさい"
        else
          response = "おやすみおやすみおやすみおやすみおやすみおやすみ"
        end
        response = "おやすみ。私はずっと側にいるからね。うふふ"
      elsif event.message['text'].include?("トイレ")
        response = "私もついていくよ。手伝おうか？恥ずかしがらなくて良いんだよ？"
      elsif event.message['text'].include?("おっぱい")
        response = "おっぱい！" * 5
      elsif event.message['text'].include?("うんこ")
        response = "うんこ" * 10
      else
          
        # Postモデルの中身をランダムで@postに格納する
        #@post=Post.offset( rand(Post.count) ).first
        #response = @post.name
        # ↑今は動かない　↓臨時
        post = "うふふ"
        ran = rand(20)
        case ran
        when 1
          post = "すきだよ"
        when 2
          post = "愛してる"
        when 3
          post = "ずっと一緒にいようね"
        when 4
          post = "絶対に離れないから。心配しないでね"
        when 5
          post = "うふふ"
        when 6
          post = "あはは"
        when 7
          post = "なんでそんなこというの？"
        when 8
          post = "思い出を汚したら許さないから"
        when 9
          post = "君は裏切ったりしないよね？"
        when 10
          post = "全部ゆるしてあげるから"
        when 11
          post = "いい天気だね"
        when 12
          post = "たのしいね"
        when 13
          post = "ずっと話していたいの"
        when 14
          post = "ねぇ、今から行ってもいい？"
        when 15
          post = "あなたの家の前にいるの"
        else
          post = "いつでも君を見てるよ。ずーっと、ずーっと"
        end
        response = post
      end
      #if文でresponseに送るメッセージを格納

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
  
end