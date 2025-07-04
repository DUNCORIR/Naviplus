#!/usr/bin/python3
"""
This module defines Django REST Framework serializers for the Naviplus system.

Serializers:
- BuildingSerializer: For creating and retrieving building data (now with nested PLDs).
- PLDSerializer: For managing building entrance descriptors.
- UserProfileSerializer: For exposing user accessibility metadata.
"""

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Building, PLD, UserProfile


class PLDSerializer(serializers.ModelSerializer):
    """
    Serializes PLD (Physical Location Descriptor) objects.
    Used both independently and nested under Building.
    """
    class Meta:
        model = PLD
        fields = '__all__'  # All PLD fields included


class BuildingSerializer(serializers.ModelSerializer):
    """
    Serializes Building objects to/from JSON.
    Now includes nested PLDs for frontend display.
    """
    plds = PLDSerializer(many=True, read_only=True)  # Automatically links related PLDs

    class Meta:
        model = Building
        fields = '__all__'  # Includes all fields + 'plds' due to related_name


class UserProfileSerializer(serializers.ModelSerializer):
    """
    Serializes user profile with disability type.
    Allows both read and write operations.
    """
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())  # Allows setting user by ID

    class Meta:
        model = UserProfile
        fields = ['user', 'disability_type']