Rails.application.routes.draw do
  # ユーザー用
  # URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ユーザー用
  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about"
    resources :users, only: [:index, :edit, :show, :update, :destroy] do
      member do
        get "followings"
        get "followers"
        get "bookmarks"
        get "notifications"
      end
      resource :relationship, only: [:create, :destroy]
    end
    resources :projects do
      get "bookmarks", on: :member
      resource :bookmark, only: [:create, :destroy]
    end
    resources :tags, only: [:index, :show] do
      get "search", on: :collection
    end
    resources :posts, shallow: true do
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :notifications, only: [:update]
  end

  # 管理者用
  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index] do
      patch "freeze", on: :member
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
