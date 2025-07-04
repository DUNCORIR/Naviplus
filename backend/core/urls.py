#!/usr/bin/python3
"""
Main URL configuration for Naviplus project.
Includes all API routes and admin panel.
"""

from django.contrib import admin
from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token
from django.shortcuts import redirect

urlpatterns = [
    path('', lambda request: redirect('api/', permanent=False)),
    path('admin/', admin.site.urls),     # Django admin
    path('api/', include('api.urls')),   # API endpoints
    path('api/token-auth/', obtain_auth_token, name='api_token_auth'),
]